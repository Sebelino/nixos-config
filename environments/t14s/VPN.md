# VPN

## Net iD

Start by installing [Net iD Enterprise](https://e-identitet.se/net-id/). The
Net iD Linux client can be downloaded from the following page, but the page is
only accessible by smartcard authentication. Hence, you will need to use a
computer which already has smartcard authentication set up for your browser in
order to access it.

https://service.pointsharp.com/secure/siths/siths_nie_download.aspx

Download `iidsetup_v6.8.5.20_siths3001_x64.tar.gz` and extract it:

```bash
$ sha256sum iidsetup_v6.8.5.20_siths3001_x64.tar.gz
88995a3a2059fb7d0b72c02f42304bcbcf7a401fd033f9aa35bd45959c23bba0

$ tar xf iidsetup_v6.8.5.20_siths3001_x64.tar.gz
$ cd iidsetup/
```

Install `aur/pcsclite` if you haven't already:

```bash
$ yay -S pcsclite
```

Edit `iid.conf`:

```diff
 [SmartCardReader PCSC]
-Library=/lib/x86_64-linux-gnu/libpcsclite.so.1
+Library=/usr/lib/libpcsclite.so
```

Then run the installation script:

```bash
$ ./install

```

Register the newly installed module:

```bash
$ ls ~/.iid/lib/libiidp11.so
$ pkcs11-tool --module /home/sebelino/.iid/lib/libiidp11.so --list-slots
$ pkcs11-register /home/sebelino/.iid/lib/libiidp11.so
$ mkdir -p ~/.config/pkcs11/modules/
$ echo "module: $HOME/.iid/lib/libiidp11.so" > ~/.config/pkcs11/modules/libiidp11
$ p11-kit list-modules
$ modutil -list -dbdir $HOME/.pki/nssdb | grep "uri.*Legitim"
```

To list certificates and private keys on the card:

```bash
$ tokenurl="$(p11tool --login --list-all | grep Legit)"
$ p11tool --login --list-all "$tokenurl"
...
Enter PIN: [Enter your card's auth code here]
```

To view the contents of a client certificate:

```bash
$ certtokenurl=$(p11tool --login --list-certs $tokenurl | grep "URL.*%43" | cut -d ' ' -f2)
$ p11tool --export "$certtokenurl" | openssl x509 -text -noout
```

## OpenConnect

OpenConnect doesn't support Pulse Secure's Host Checker, but there exists a
fork that does. Download it and check out the correct branch:

```bash
$ mkdir -p ~/src
$ cd ~/src/
$ git clone https://gitlab.com/yzzyx/openconnect
$ cd openconnect/
$ git checkout pulse-tncc
```

Apply the following patch to `gnutls-dtls.c`:

```diff
-       err = gnutls_init(&dtls_ssl, GNUTLS_CLIENT|GNUTLS_DATAGRAM|GNUTLS_NONBLOCK|GNUTLS_NO_EXTENSIONS);
+       err = gnutls_init(&dtls_ssl, GNUTLS_CLIENT|GNUTLS_DATAGRAM|GNUTLS_NONBLOCK|GNUTLS_EXT_NONE);
```

Compile from source:

```bash
$ ./autogen.sh
$ ./configure
$ make
```

Run the VPN using the [`openconnect.sh`](./vpn/openconnect.sh) wrapper script:

```bash
$ ~/nixos-config/environments/t14s/vpn/openconnect.sh
```

You should now have a working VPN connection.

To avoid certificate errors when browsing sites, import these root CA
certificates at the `Authorities` tab in Chromium:

* `./vpn/secrets/Region Stockholm RSA Rot CA v3.pem`
* `./vpn/secrets/SITHS e-id Root CA v2.pem.pem`

![image](https://github.com/Sebelino/nixos-config/assets/837775/93009875-9ade-48fe-8192-543b107322ef)

## RDP

Install `extra/remmina` and `extra/freerdp`:

```bash
$ yay -S remmina freerdp
```

Ensure your VPN is running and functional. Then run:

```bash
$ server=my.rdp.server.com
$ hsa_id=gxxx
$ domain=GAIA
$
$ remmina -c "rdp://${domain}\\${hsa_id}@${server}"
```

Enter your password and you should be able to connect to the server over RDP.

To turn on the `Toggle dynamic resolution update` setting in a persisted
manner, add `resolution_mode=1` and `scale=2` to the config file:

```bash
$ cat ~/.config/remmina/remmina.pref | grep -A4 "\[remmina\]"
[remmina]
name=
ignore-tls-errors=1
resolution_mode=1
scale=2
```

## Client cert authentication with `curl`

Install `extra/libp11`:

```bash
$ yay -S libp11
```

You should now be able to authenticate with `curl` and `openssl` using a client
certificate and private key specified using `pkcs11` strings:

```bash
curl -v 'https://certauth.federation.sll.se/adfs/certauth/?...' \
  ...
  --cert 'pkcs11:...;type=cert' \
  --key 'pkcs11:...;type=private'
```

## Unresolved issues

### ADFS client authentication

TLS client authentication against https://certauth.federation.sll.se via the
ADFS tenant produces a HTTP 200 with the error message: `No valid client
certificate found in the request`. Based on my investigations with Wireshark,
the server request a client certificate, but Chromium is never prompting me to
select a certificate, and instead sends a TLS message containing a Certificate
field containing zero (0) certificates.

On the other hand, making the same request using `curl` with
`--cert 'pkcs11:...;type=cert' --key 'pkcs11:...;type=private`
produces a HTTP 302, which matches what I expect in a successful client cert
authentication flow. Wireshark reveals that `curl` sends a TLS message
containing a Certificate fields containing one (1) certificate as expected.

So my guess is that this is a Chromium issue. OTOH, I am able to successfully
authenticate with a client cert against https://idp2.sll.se with Chromium, and
I am prompted to select a cert. So perhaps Chromium lacks support for a certain
type of client cert authentication flow?

Whether a VPN is running or not appears to be of no consequence, since I am
able to successfully authenticate with Chrome on my other computer with the VPN
turned off.

### Split tunneling

Video/audio traffic from Teams seems to enter the VPN (sam.sll.se), possibly
worsening call quality. It's worth investigating
setting up OpenConnect to exclude this traffic using
[split tunneling](https://gist.github.com/stefancocora/686bbce938f27ef72649a181e7bd0158).

## Wifi

```
$ cat /home/sebelino/misc/karolinska/clientcert/smartcard.openssl.cnf
openssl_conf = SSL_Configuration

[ SSL_Configuration ]
engines = SSL_Engines

[ SSL_Engines ]
pkcs11 = ENG_PKCS11

[ ENG_PKCS11 ]
dynamic_path = /usr/lib/engines-3/pkcs11.so
MODULE_PATH = /home/sebelino/.iid/lib/libiidp11.so
```

```
$ ls -lah /etc/ssl/certs/Region_Stockholm_RSA_Rot_CA_v3.pem
lrwxrwxrwx 1 root root 72 Nov  2 20:40 /etc/ssl/certs/Region_Stockholm_RSA_Rot_CA_v3.pem -> ../../ca-certificates/extracted/cadir/Region_Stockholm_RSA_Rot_CA_v3.pem
```

```
$ cat ./wpa_supplicant.conf
network={
    ssid="SLL-Access"
    key_mgmt=WPA-EAP
    eap=TLS
    identity="sebastian.v.olsson@regionstockholm.se"
    client_cert="pkcs11:model=SITHS%20Standard;manufacturer=Thales;serial=2258385715438660;token=SITHS%20e-id%20kort%20%28Legitimering%29;id=%49%64%65%6E%74%69%66%69%63%61%74%69%6F%6E%43;object=Sebastian%20Olsson%2C%20Stockholms%20L%C3%A4ns%20Landsting;type=cert"
    private_key="pkcs11:model=SITHS%20Standard;manufacturer=Thales;serial=2258385715438660;token=SITHS%20e-id%20kort%20%28Legitimering%29;id=%49%64%65%6E%74%69%66%69%63%61%74%69%6F%6E%43;type=private"
    private_key_passwd="090897"
    # Should be specified, but if omitted, similar to --insecure
    #ca_cert="/etc/ssl/certs/Region_Stockholm_RSA_Rot_CA_v3.pem"
}
```

$ OPENSSL_CONF=/home/sebelino/misc/karolinska/clientcert/smartcard.openssl.cnf curl --engine list
Build-time engines:
  rdrand
  dynamic
  pkcs11

$ OPENSSL_CONF=/home/sebelino/misc/karolinska/clientcert/smartcard.openssl.cnf sudo -E wpa_supplicant -c ./wpa_supplicant.conf -i wlp1s0

wpa_supplicant should now prompt for a PIN:

```
Enter PKCS#11 token PIN for SITHS e-id kort (Legitimering):
```

Now I am stuck on a timeout:

cat CTRL-EVENT-EAP-FAILURE.log
SSL: SSL3 alert: read (remote end reported an error):fatal:unknown CA

Hypothesis: the TLS server rejects the client's client certificate because the client does not send the entire cert chain,
i.e. the issuer of Sebastian Olsson HSAID, i.e. "SITHS e-id Person HSA-id 3 CA v1"

https://stackoverflow.com/a/6363952

I could probably check what certs are sent from the client side during the TLS handshake, using openssl s_server.
I could also try appending the client CA issuer to client_ca_chain.pem and update wpa_supplicant.conf config to use this pem file instead of the pkcs11 url

In fact, this would explain why it doesn't work on local admin Windows: we simply haven't added the Issuer cert of the client cert (or server cert?) to the Windows wifi settings.

2023-11-17:

I tried setting up an example with s_client:

```
$ cd /home/sebelino/src/play/tls/s_server/
$ openssl s_server -port 8000 -cert rootca.out.crt -key rootca.out.key -CAfile /home/sebelino/misc/karolinska/hsaid_root.crt -verify_return_error -Verify 1 -WWW -trace

$ curl -v https://root.sebelino.com:8000 --cert /home/sebelino/misc/karolinska/wifi/client_ca_chain.pem --key 'pkcs11:model=SITHS%20Standard;manufacturer=Thales;serial=2258385715438660;token=SITHS%20e-id%20kort%20%28Legitimering%29;id=%49%64%65%6E%74%69%66%69%63%61%74%69%6F%6E%43;type=private' --cacert /home/sebelino/src/play/tls/s_server/rootca.out.crt -L

$ # Or:
$ OPENSSL_CONF=/home/sebelino/misc/karolinska/clientcert/smartcard.openssl.cnf openssl s_client -connect root.sebelino.com:8000 -servername root.sebelino.com -key 'pkcs11:model=SITHS%20Standard;manufacturer=Thales;serial=2258385715438660;token=SITHS%20e-id%20kort%20%28Legitimering%29;id=%49%64%65%6E%74%69%66%69%63%61%74%69%6F%6E%43;type=private' -cert /home/sebelino/misc/karolinska/43.pem -cert_chain /home/sebelino/misc/karolinska/wifi/43_intermediate.pem -CAfile /home/sebelino/src/play/tls/s_server/rootca.out.crt -keyform engine -engine pkcs11
```

but with `curl`, I keep seeing this error in the server:

```
Received Record
Header:
  Version = TLS 1.2 (0x303)
  Content Type = ApplicationData (23)
  Length = 19
  Inner Content Type = Alert (21)
    Level=fatal(2), description=internal error(80)

4097EA5B297F0000:error:0A000438:SSL routines:ssl3_read_bytes:tlsv1 alert internal error:ssl/record/rec_layer_s3.c:1586:SSL alert number 80
```

and with `openssl s_client`, I see this:

```
    Level=fatal(2), description=decrypt error(51)
```


