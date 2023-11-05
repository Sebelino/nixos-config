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
