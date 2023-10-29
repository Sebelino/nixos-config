# VPN

## Net iD

Start by installing Net iD Enterprise. The Net iD Linux client can be
downloaded from the following page, but the page is only accessible by
smartcard authentication. Hence, you will need to use a computer which already
has smartcard authentication set up for your browser in order to access it.

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

Create a network interface for OpenConnect to use (taken from
[here](https://www.infradead.org/openconnect/nonroot.html)):

```bash
$ sudo ip tuntap add vpn0 mode tun user "$USER"
$ ip link show
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
