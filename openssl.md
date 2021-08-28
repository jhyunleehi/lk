# openssl 

## ubuntu 18.04

###  openssl 확인

```sh 
root@dev:~# apt list openssl -a
Listing... Done
openssl/bionic-updates,bionic-security 1.1.1-1ubuntu2.1~18.04.13 amd64 [upgradable from: 1.1.1-1ubuntu2.1~18.04.9]
openssl/now 1.1.1-1ubuntu2.1~18.04.9 amd64 [installed,upgradable to: 1.1.1-1ubuntu2.1~18.04.13]
openssl/bionic 1.1.0g-2ubuntu4 amd64
```



#### localhost:80 에러...

```sh
root@dev:~# openssl s_client -connect localhost:80
CONNECTED(00000005)
140362729537984:error:1408F10B:SSL routines:ssl3_get_record:wrong version number:../ssl/record/ssl3_record.c:332:
---
no peer certificate available
---
No client certificate CA names sent
---
SSL handshake has read 5 bytes and written 311 bytes
Verification: OK
---
New, (NONE), Cipher is (NONE)
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
Early data was not sent
Verify return code: 0 (ok)
---

root@ubunt16:~# apt list openssl -a
Listing... 완료
openssl/xenial-updates,xenial-security 1.0.2g-1ubuntu4.20 amd64 [upgradable from: 1.0.2g-1ubuntu4.16]
openssl/now 1.0.2g-1ubuntu4.16 amd64 [installed,upgradable to: 1.0.2g-1ubuntu4.20]
openssl/xenial 1.0.2g-1ubuntu4 amd64
```



```sh
root@ubuntu18:~# ssh 192.168.57.5
The authenticity of host '192.168.57.5 (192.168.57.5)' can't be established.
ECDSA key fingerprint is SHA256:MBwc3WCgtGdPlPHoANARxabPMA3ysOLxHgMhIGJ1DSw.
Are you sure you want to continue connecting (yes/no)? ^C
root@ubuntu18:~# ssh -v 192.168.57.5
OpenSSH_7.6p1 Ubuntu-4ubuntu0.5, OpenSSL 1.0.2n  7 Dec 2017
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: Applying options for *
debug1: Connecting to 192.168.57.5 [192.168.57.5] port 22.
debug1: Connection established.
debug1: permanently_set_uid: 0/0
debug1: identity file /root/.ssh/id_rsa type 0
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_rsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_dsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_dsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ecdsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ecdsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ed25519 type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ed25519-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.5
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.2p2 Ubuntu-4ubuntu2.10
debug1: match: OpenSSH_7.2p2 Ubuntu-4ubuntu2.10 pat OpenSSH* compat 0x04000000
debug1: Authenticating to 192.168.57.5:22 as 'root'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256@libssh.org
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY <<<=====
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:MBwc3WCgtGdPlPHoANARxabPMA3ysOLxHgMhIGJ1DSw
The authenticity of host '192.168.57.5 (192.168.57.5)' can't be established.
ECDSA key fingerprint is SHA256:MBwc3WCgtGdPlPHoANARxabPMA3ysOLxHgMhIGJ1DSw.
Are you sure you want to continue connecting (yes/no)?
```



#### openssl s_client -connect 192.168.57.5:22

```sh
root@ubuntu18:~# openssl s_client -connect 192.168.57.5:22
CONNECTED(00000005)
140514426405312:error:1408F10B:SSL routines:ssl3_get_record:wrong version number:../ssl/record/ssl3_record.c:332:
---
no peer certificate available
---
No client certificate CA names sent
---
SSL handshake has read 5 bytes and written 314 bytes
Verification: OK
---
New, (NONE), Cipher is (NONE)
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
Early data was not sent
Verify return code: 0 (ok)
---
```





### ubunt 16.4

#### openssl

```sh
root@ubunt16:~# apt list openssl -a
Listing... 완료
openssl/xenial-updates,xenial-security 1.0.2g-1ubuntu4.20 amd64 [upgradable from: 1.0.2g-1ubuntu4.16]
openssl/now 1.0.2g-1ubuntu4.16 amd64 [installed,upgradable to: 1.0.2g-1ubuntu4.20]
openssl/xenial 1.0.2g-1ubuntu4 amd64
```

#### ssh 설치

```sh
root@ubunt16:~# apt list openssl -a
Listing... 완료
openssl/xenial-updates,xenial-security 1.0.2g-1ubuntu4.20 amd64 [upgradable from: 1.0.2g-1ubuntu4.16]
openssl/now 1.0.2g-1ubuntu4.16 amd64 [installed,upgradable to: 1.0.2g-1ubuntu4.20]
openssl/xenial 1.0.2g-1ubuntu4 amd64
```



### ca-cetificates

```
$ sudo cp mycert.cer /usr/share/ca-certificates/mycert.pem
$ sudo dpkg-reconfigure ca-certificates
$ sudo update-ca-certificates
$ git config --global http.sslCAInfo /usr/share/ca-certificates/mycert.pem
```

#### SSL 인증서 종류

* pem : PEM (Privacy Enhanced Mail)은 Base64 인코딩된 ASCII 텍스트 이다. 파일 구분 확장자로 .pem 을 주로 사용한다. 노트패드에서 열기/수정도 가능하다. 개인키, 서버인증서, 루트인증서, 체인인증서 및 SSL 발급 요청시 생성하는 CSR 등에 사용되는 포맷이며, 가장 광범위하고 거의 99% 대부분의 시스템에 호환되는 산업 표준 포맷이다. (대부분 텍스트 파일)
* crt: 거의 대부분 PEM 포맷이며, 주로 유닉스/리눅스 기반 시스템에서 인증서 파일임을 구분하기 위해서 사용되는 확장자 이다. 다른 확장자로 .cer 도 사용된다. 파일을 노트패드 등으로 바로 열어 보면 PEM 포맷인지 바이너리 포맷인지 알수 있지만 99% 는 Base64 PEM 포맷이라고 봐도 무방하다. (대부분 텍스트 파일)
* cer: 거의 대부분 PEM 포맷이며, 주로 Windows 기반에서 인증서 파일임을 구분하기 위해서 사용되는 확장자 이다. crt 확장자와 거의 동일한 의미이며, cer 이나 crt 확장자 모두 윈도우에서는 기본 인식되는 확장자이다. 저장할때 어떤 포맷으로 했는지에 따라 다르며, 이름 붙이기 나름이다.
* csr: Certificate Signing Request 의 약자이며 거의 대부분 PEM 포맷이다. SSL 발급 신청을 위해서 본 파일 내용을 인증기관 CA 에 제출하는 요청서 파일임을 구분하기 위해서 붙이는 확장자 이다. (대부분 텍스트 파일)
* der: Distinguished Encoding Representation (DER) 의 약자이며, 바이너리 포맷이다. 노트패드등으로 열어 봐서는 알아 볼수 없다. 바이너리 인코딩 포맷을 읽을수 있는 인증서 라이브러리를 통해서만 내용 확인이 가능하다. 사설 또는 금융등 특수 분야 및 아주 오래된 구형 시스템을 제외하고는, 최근 웹서버 SSL 작동 시스템 에서는 흔히 사용되는 포맷은 아니다. (바이너리 이진 파일)
* pfx/.p12 : PKCS#12 바이너리 포맷이며, Personal Information Exchange Format 를 의미한다. 주로 Windows IIS 기반에서 인증서 적용/이동시 활용된다. 주요 장점으로는 개인키,서버인증서,루트인증서,체인인증서를 모두 담을수 있어서 SSL 인증서 적용이나 또는 이전시 상당히 유용하고 편리하다. Tomcat 등 요즘에는 pfx 설정을 지원하는 서버가 많아지고 있다.  (바이너리 이진 파일)
* key: 주로 openssl 및 java 에서 개인키 파일임을 구분하기 위해서 사용되는 확장자이다. PEM 포맷일수도 있고 DER 바이너리 포맷일수도 있으며, 파일을 열어봐야 어떤 포맷인지 알수가 있다. 저장할때 어떤 포맷으로 했는지에 따라 다르며, 확장자는 이름 붙이기 나름이다.



## ssh

### ssh-keygen -t rsa -b 1024

```sh
root@ubunt16:~# ssh-keygen -t rsa -b 1024
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.
Your public key has been saved in /root/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:3IwDVA+27KBSRRr/ZBjmGJcvh004VmLfWj4LQXxvi9A root@ubunt16.04

root@ubunt16:~/.ssh# ssh-copy-id 192.168.57.31
```



#### ssh -v 

```sh
root@dev:/etc/ssl# ssh -v 192.168.57.5
OpenSSH_7.6p1 Ubuntu-4ubuntu0.5, OpenSSL 1.0.2n  7 Dec 2017
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: Applying options for *
debug1: Connecting to 192.168.57.5 [192.168.57.5] port 22.
debug1: Connection established.
debug1: identity file /root/.ssh/id_rsa type 0
debug1: identity file /root/.ssh/id_rsa-cert type -1
debug1: identity file /root/.ssh/id_dsa type -1
debug1: identity file /root/.ssh/id_dsa-cert type -1
debug1: identity file /root/.ssh/id_ecdsa type -1
debug1: identity file /root/.ssh/id_ecdsa-cert type -1
debug1: identity file /root/.ssh/id_ed25519 type -1
debug1: identity file /root/.ssh/id_ed25519-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_7.6p1 Ubuntu-4ubuntu0.5
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.2p2 Ubuntu-4ubuntu2.10
debug1: match: OpenSSH_7.2p2 Ubuntu-4ubuntu2.10 pat OpenSSH* compat 0x04000000
debug1: Authenticating to 192.168.57.5:22 as 'root'
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256@libssh.org
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY <<== 이것에 대한 이유는 ?

<<< 여기서 hang>>
<<< Connection reset by 70.150.192.202 port 22>>>

debug1: Server host key: ecdsa-sha2-nistp256 SHA256:MBwc3WCgtGdPlPHoANARxabPMA3ysOLxHgMhIGJ1DSw
debug1: Host '192.168.57.5' is known and matches the ECDSA host key.
debug1: Found key in /root/.ssh/known_hosts:2
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<rsa-sha2-256,rsa-sha2-512>
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,password
debug1: Next authentication method: publickey
debug1: Offering public key: RSA SHA256:gKEzQgkA5K8z+St/iPkedp+HoaeRJoL8NKjg9PtJNM8 /root/.ssh/id_rsa
debug1: Authentications that can continue: publickey,password
debug1: Trying private key: /root/.ssh/id_dsa
debug1: Trying private key: /root/.ssh/id_ecdsa
debug1: Trying private key: /root/.ssh/id_ed25519
debug1: Next authentication method: password
root@192.168.57.5's password:
```



#### openssl

```sh
root@ubunt16:~# openssl s_client -connect 192.168.57.31:22
CONNECTED(00000003)
139779288340120:error:140770FC:SSL routines:SSL23_GET_SERVER_HELLO:unknown protocol:s23_clnt.c:794:
---
no peer certificate available
---
No client certificate CA names sent
---
SSL handshake has read 7 bytes and written 305 bytes
---
New, (NONE), Cipher is (NONE)
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : 0000
    Session-ID: 
    Session-ID-ctx: 
    Master-Key: 
    Key-Arg   : None
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    Start Time: 1630132153
    Timeout   : 300 (sec)
    Verify return code: 0 (ok)
---
```



```sh
root@dev:/etc/ssl# openssl s_client -connect 192.168.57.5:22 
CONNECTED(00000005)
140543585358272:error:1408F10B:SSL routines:ssl3_get_record:wrong version number:../ssl/record/ssl3_record.c:332:
---
no peer certificate available
---
No client certificate CA names sent
---
SSL handshake has read 5 bytes and written 314 bytes
Verification: OK
---
New, (NONE), Cipher is (NONE)
Secure Renegotiation IS NOT supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
Early data was not sent
Verify return code: 0 (ok)
---
```





## nginx  ssl

###  nginx  ssl 설치

#### 인증서 생성

```sh
root@dev:/etc/nginx/ssl# openssl x509 -req -days 365 -in test.csr -signkey test.key -out test.crt
```

#### ssl 인증서 생성

```sh
root@dev:/etc/nginx/ssl# openssl x509 -req -days 365 -in test.csr -signkey test.key -out test.crt
Signature ok
subject=C = AU, ST = Some-State, O = Internet Widgits Pty Ltd, CN = jhyunlee, emailAddress = jhyunlee@naver.com
Getting Private key
```



####  nginx ssl 적용 : /etc/nginx/sites-available/default

```sh
server {
    listen 443;

    root /var/www/html/frontui;
    index index.html index.htm

    server_name 192.168.x.x;

    ssl on;
    ssl_certificate /etc/nginx/ssl/test.crt;
    ssl_certificate_key /etc/nginx/ssl/test.key;

    location / {
        proxy_http_version 1.1;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Protocol $scheme;
        proxy_set_header X-Real_IP $remote_addr;
    }
}

server {
    listen 80;

    server_name 192.168.x.x;
    return 301 https://$host$request_uri;
}
```

### ssl Test

#### openssl s_client -connect 192.168.57:443

```log
root@ubunt16:~# openssl s_client -connect 192.168.57.31:443
CONNECTED(00000003)
depth=0 C = AU, ST = Some-State, O = Internet Widgits Pty Ltd, CN = jhyunlee, emailAddress = jhyunlee@naver.com
verify error:num=18:self signed certificate
verify return:1
depth=0 C = AU, ST = Some-State, O = Internet Widgits Pty Ltd, CN = jhyunlee, emailAddress = jhyunlee@naver.com
verify return:1
---
Certificate chain
 0 s:/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd/CN=jhyunlee/emailAddress=jhyunlee@naver.com
   i:/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd/CN=jhyunlee/emailAddress=jhyunlee@naver.com
---
Server certificate
-----BEGIN CERTIFICATE-----
MIIDfTCCAmUCFH0ldXoYxIteoKIJDPoqM42UczU2MA0GCSqGSIb3DQEBCwUAMHsx
CzAJBgNVBAYTAkFVMRMwEQYDVQQIDApTb21lLVN0YXRlMSEwHwYDVQQKDBhJbnRl
cm5ldCBXaWRnaXRzIFB0eSBMdGQxETAPBgNVBAMMCGpoeXVubGVlMSEwHwYJKoZI
hvcNAQkBFhJqaHl1bmxlZUBuYXZlci5jb20wHhcNMjEwODI4MDcxNzM3WhcNMjIw
ODI4MDcxNzM3WjB7MQswCQYDVQQGEwJBVTETMBEGA1UECAwKU29tZS1TdGF0ZTEh
MB8GA1UECgwYSW50ZXJuZXQgV2lkZ2l0cyBQdHkgTHRkMREwDwYDVQQDDAhqaHl1
bmxlZTEhMB8GCSqGSIb3DQEJARYSamh5dW5sZWVAbmF2ZXIuY29tMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2w6vDNWSfWJromDOFF6r7onWY/8M/pTS
4+7VCuYHFFDAKySrN5SbeALqGwaxBv+DF2/H04QpJPt3ewGmK4TWNUjfZmMuD1QH
ySU7xa3xQmhe3sK0T7HwOV9FZYcQyVO1z6FxJZSfj2MmnjlV05ikq9B8hKpAofmk
pLstvIM4sagUZiiAGtFOFFXa5jDkLuCuBfhVyi/rwskju3EKZlk65E6mOtYoGzPG
Naa5D5DRWTSm+orE84w9qjkaSmyqw3Bbm/V8H8YJSbeV36BScaG13Fy3Z1NO5kKO
7l6AqdlwgbJwoinudLKpVmHaymgvgVN6QCkYrqr0B4adeL39kXfW4wIDAQABMA0G
CSqGSIb3DQEBCwUAA4IBAQB04NodzbnYhQuuM6dzf+K14+nkxaxsogHUxN1KtWGu
+19bfgzyRorZgjYcuuvEXQQs+qu1oTwIzZ9zDGH9B54vGkN+Mi/wrxkyuz7tjmc9
UaDujXLErI66KA2DiwmhmGZ/J3EB5QZaABWo7S23P+FJRiQZ3n3e06GS8a0NzNy0
KmP77ZaXf9qhYGrvfTb8oixVvLxBhJEZEqkh++fomy4adwRadiexKkCP+BOdW486
qADFKYxfsjYGHjR7v4zNa/ls7PmGKnRnT7cKm8yG0ncO/pBpkoU4Ss6wi3fRb+vr
njQgu59HxRVKTOFLHk4tjWuMH6ifaFtotSM5Ao/1OPbP
-----END CERTIFICATE-----
subject=/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd/CN=jhyunlee/emailAddress=jhyunlee@naver.com
issuer=/C=AU/ST=Some-State/O=Internet Widgits Pty Ltd/CN=jhyunlee/emailAddress=jhyunlee@naver.com
---
No client certificate CA names sent
Peer signing digest: SHA256
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 1567 bytes and written 431 bytes
---
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: 414BEDF51BA9120AF188F840D1A0A7FE3D25B78E7BFDF2F8579EDCAB2B8F7782
    Session-ID-ctx: 
    Master-Key: D31DDED11367027196AF14D8C6388F1E06947A023831C17E364E2C3BA1C889DAA3B7F2C85FAE2BC869786550162AE903
    Key-Arg   : None
    PSK identity: None
    PSK identity hint: None
    SRP username: None
    TLS session ticket lifetime hint: 300 (seconds)
    TLS session ticket:
    0000 - 25 20 7e 35 19 dc 5b 67-97 e9 cc 65 a9 c4 42 6b   % ~5..[g...e..Bk
    0010 - 2d ad 5e c7 ca 4f 26 46-8a c8 a5 97 31 53 51 0b   -.^..O&F....1SQ.
    0020 - 6a f3 8e 28 04 2a 7e 94-2b b2 4b 39 fc d2 9c a8   j..(.*~.+.K9....
    0030 - 67 f4 74 6d e4 34 83 90-d0 c7 87 40 81 4f c3 8c   g.tm.4.....@.O..
    0040 - 48 86 e2 71 79 9c fa ca-f2 93 34 2e a2 68 7a a7   H..qy.....4..hz.
    0050 - b2 ed 2b 6c 0d 9c c2 91-9e 48 1e e0 9a c2 66 13   ..+l.....H....f.
    0060 - 01 fd 25 04 a6 87 39 89-6a d1 e4 14 be 74 9c 49   ..%...9.j....t.I
    0070 - b4 85 16 44 f3 78 d2 6e-c1 bf cc 20 b1 9b 8f 3b   ...D.x.n... ...;
    0080 - e3 78 49 8e 7d 57 db 31-3e ce 03 7e 18 58 94 17   .xI.}W.1>..~.X..
    0090 - 1a 2f f7 a3 6d bd bc 7f-13 19 93 25 1d d4 7c 1f   ./..m......%..|.
    00a0 - ab e7 7d 44 65 8a 70 ae-05 57 73 62 0b f0 8e 72   ..}De.p..Wsb...r

    Start Time: 1630136570
    Timeout   : 300 (sec)
    Verify return code: 18 (self signed certificate)
---
 closed
```



####  openssl s_client -protocol : -ssl2, -ss3, -tls1, -dtls

```
 -ssl2         - just use SSLv2
 -ssl3         - just use SSLv3
 -tls1_2       - just use TLSv1.2
 -tls1_1       - just use TLSv1.1
 -tls1         - just use TLSv1
 -dtls1        - just use DTLSv1
```

* TEST cases

```
# openssl s_client  -connect 192.168.57.31:443 -ssl2 
unknown option -ssl2

# openssl s_client  -connect 192.168.57.31:443 -ssl3
140111076378264:error:140A90C4:SSL routines:SSL_CTX_new:null ssl method passed:ssl_lib.c:1878:

# openssl s_client  -connect 192.168.57.31:443 -tls1_1
Server certificate
No client certificate CA names sent
Server Temp Key: ECDH, P-256, 256 bits
SSL handshake has read 1589 bytes and written 347 bytes
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-SHA
Server public key is 2048 bit
Secure Renegotiation IS supported
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.1
    Cipher    : ECDHE-RSA-AES256-SHA
    Expansion: NONE
    
# openssl s_client  -connect 192.168.57.31:443 -tls1_2
Server certificate
---
No client certificate CA names sent
Peer signing digest: SHA256
Server Temp Key: ECDH, P-256, 256 bits
---
SSL handshake has read 1567 bytes and written 431 bytes
---
New, TLSv1/SSLv3, Cipher is ECDHE-RSA-AES256-GCM-SHA384
Server public key is 2048 bit
Secure Renegotiation IS supported
Compression: NONE
Expansion: NONE
No ALPN negotiated
SSL-Session:
    Protocol  : TLSv1.2
    Cipher    : ECDHE-RSA-AES256-GCM-SHA384
    Session-ID: E7FD7E496B1CD4C6ECA7AAE2F32608E2A8ECDDC13C4BEE6211478DBDCC0A799C
    TLS session ticket lifetime hint: 300 (seconds)
```



#### openssl version -a

```sh 
root@ubunt16:~# openssl version -a
OpenSSL 1.0.2g  1 Mar 2016
built on: reproducible build, date unspecified
platform: debian-amd64
options:  bn(64,64) rc4(8x,int) des(idx,cisc,16,int) blowfish(idx) 
compiler: cc -I. -I.. -I../include  -fPIC -DOPENSSL_PIC -DOPENSSL_THREADS -D_REENTRANT -DDSO_DLFCN -DHAVE_DLFCN_H -m64 -DL_ENDIAN -g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -Wl,-Bsymbolic-functions -Wl,-z,relro -Wa,--noexecstack -Wall -DMD32_REG_T=int -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT -DOPENSSL_BN_ASM_MONT5 -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DMD5_ASM -DAES_ASM -DVPAES_ASM -DBSAES_ASM -DWHIRLPOOL_ASM -DGHASH_ASM -DECP_NISTZ256_ASM
OPENSSLDIR: "/usr/lib/ssl"
```



## tcpdump

```sh
# tcpdump -i ens160 -w  dump.pcap
# tcpdump -i eth0   -w  dump.pcap
# tcpdump -i eth0 -c 5
# tcpdump -i eth0 -A  //print ascii
# tcpdump -D  //display available interfaces 
# tcpdump -i etho tcp
# tcpdump -i etho0  port 22
# tcpdump -i etho0  src 192.168.56.10
# tcpdump -i etho0  dst 192.168.56.11
```



#### Verification error : self signed certificate 

```sh
server가 제공한 인증서가 self sigined cetificated라고 해서 ca 인증서에 넣었더니 
다행해 그 부분은 ok 통과 하는데.. 역시나 문제는 계속 발생되는 구나....
```



#### update ca-certificates

```sh
Copy your CA to dir /usr/local/share/ca-certificates/
# sudo update-ca-certificates --fresh
# sudo cp foo.crt /usr/local/share/ca-certificates/foo.crt
# Update the CA store: sudo update-ca-certificates

# Remove your CA.
# Update the CA store: sudo update-ca-certificates --fresh
```



### tcpdump

#### ssh: 192.168.57.5 ->192.168.57.31

```log
21:13:22.719350 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [S], seq 849408894, win 64240, options
21:13:22.719397 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [S.], seq 1106209652, ack 849408895, w
21:13:22.719526 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [.], ack 1, win 502, options [nop,nop,
21:13:22.719779 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 1:43, ack 1, win 502, option
21:13:22.719789 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 43, win 509, options [nop,nop
21:13:22.726786 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 1:42, ack 43, win 509, optio
21:13:22.727023 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [.], ack 42, win 502, options [nop,nop
21:13:22.727360 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 43:1379, ack 42, win 502, op
21:13:22.727370 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 1379, win 501, options [nop,n
21:13:22.727911 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 42:1122, ack 1379, win 501, 
21:13:22.729948 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 1379:1427, ack 1122, win 501
21:13:22.729964 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 1427, win 501, options [nop,n
21:13:22.734100 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 1122:1574, ack 1427, win 501
21:13:22.736956 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 1427:1443, ack 1574, win 501
21:13:22.737091 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 1443:1487, ack 1574, win 501
21:13:22.737097 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 1487, win 501, options [nop,n
21:13:22.737170 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 1574:1618, ack 1487, win 501
21:13:22.737302 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 1487:1547, ack 1618, win 501
21:13:22.737310 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 1547, win 501, options [nop,n
21:13:22.737611 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 1618:1670, ack 1547, win 501
21:13:22.737936 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 1547:1791, ack 1670, win 501
21:13:22.737945 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 1791, win 501, options [nop,n
21:13:22.738940 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 1670:1874, ack 1791, win 501
21:13:22.739525 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 1791:2187, ack 1874, win 501
21:13:22.739534 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 2187, win 501, options [nop,n
21:13:22.739968 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 1874:1902, ack 2187, win 501
21:13:22.740138 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 2187:2299, ack 1902, win 501
21:13:22.740147 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 2299, win 501, options [nop,n
21:13:22.915732 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 1902:2402, ack 2299, win 501
21:13:22.958241 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [.], ack 2402, win 501, options [nop,n
21:13:22.958282 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 2402:2446, ack 2299, win 501
21:13:22.958443 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [.], ack 2446, win 501, options [nop,n
21:13:22.958587 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [P.], seq 2299:2751, ack 2446, win 501
21:13:22.958596 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [.], ack 2751, win 501, options [nop,n
21:13:22.959343 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 2446:2554, ack 2751, win 501
21:13:22.961126 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 2554:3342, ack 2751, win 501
21:13:22.961461 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [.], ack 3342, win 501, options [nop,n
21:13:22.987219 IP ubuntu18.04.ssh > 192.168.57.5.40272: Flags [P.], seq 3342:3418, ack 2751, win 501
21:13:23.030596 IP 192.168.57.5.40272 > ubuntu18.04.ssh: Flags [.], ack 3418, win 501, options [nop,n
```



#### debug1: expecting SSH2_MSG_KEX_ECDH_REPLY

이것을 달라고 ssh Client는 요구 하는데 서버에서  전달되는 것은 아래 3가지...

```sh
ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521
ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521
```

* 바로 이부분인데...  오류가 나는 부분은 Connection reset by 70.150.192.202 port 22  이렇게 RST 해버리는데... 

```
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:hcHb0w2X5IdOV2jn27jhqzaRlsafGmwvFRP4IEXWQlU
debug1: Host '192.168.57.31' is known and matches the ECDSA host key.
debug1: Found key in /root/.ssh/known_hosts:
```



#### ssh -o KexAlgorithms=ecdh-sha2-nistp521  192.168.57.31 



#### ssh -vvv 좀 더 

```sh
root@ubunt16:~# ssh -vvv  192.168.57.31
OpenSSH_7.2p2 Ubuntu-4ubuntu2.10, OpenSSL 1.0.2g  1 Mar 2016
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: Applying options for *
debug2: resolving "192.168.57.31" port 22
debug2: ssh_connect_direct: needpriv 0
debug1: Connecting to 192.168.57.31 [192.168.57.31] port 22.
debug1: Connection established.
debug1: permanently_set_uid: 0/0
debug1: identity file /root/.ssh/id_rsa type 1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_rsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_dsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_dsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ecdsa type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ecdsa-cert type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ed25519 type -1
debug1: key_load_public: No such file or directory
debug1: identity file /root/.ssh/id_ed25519-cert type -1
debug1: Enabling compatibility mode for protocol 2.0
debug1: Local version string SSH-2.0-OpenSSH_7.2p2 Ubuntu-4ubuntu2.10
debug1: Remote protocol version 2.0, remote software version OpenSSH_7.6p1 Ubuntu-4ubuntu0.5
debug1: match: OpenSSH_7.6p1 Ubuntu-4ubuntu0.5 pat OpenSSH* compat 0x04000000
debug2: fd 3 setting O_NONBLOCK
debug1: Authenticating to 192.168.57.31:22 as 'root'
debug3: hostkeys_foreach: reading file "/root/.ssh/known_hosts"
debug3: record_hostkey: found key type ECDSA in file /root/.ssh/known_hosts:1
debug3: load_hostkeys: loaded 1 keys from 192.168.57.31
debug3: order_hostkeyalgs: prefer hostkeyalgs: ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521
debug3: send packet: type 20
debug1: SSH2_MSG_KEXINIT sent
debug3: receive packet: type 20
debug1: SSH2_MSG_KEXINIT received
debug2: local client KEXINIT proposal
debug2: KEX algorithms: curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group-exchange-sha1,diffie-hellman-group14-sha1,ext-info-c
debug2: host key algorithms: ecdsa-sha2-nistp256-cert-v01@openssh.com,ecdsa-sha2-nistp384-cert-v01@openssh.com,ecdsa-sha2-nistp521-cert-v01@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256,ssh-rsa
debug2: ciphers ctos: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,3des-cbc
debug2: ciphers stoc: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,aes128-cbc,aes192-cbc,aes256-cbc,3des-cbc
debug2: MACs ctos: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: MACs stoc: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: compression ctos: none,zlib@openssh.com,zlib
debug2: compression stoc: none,zlib@openssh.com,zlib
debug2: languages ctos: 
debug2: languages stoc: 
debug2: first_kex_follows 0 
debug2: reserved 0 
debug2: peer server KEXINIT proposal
debug2: KEX algorithms: curve25519-sha256,curve25519-sha256@libssh.org,ecdh-sha2-nistp256,ecdh-sha2-nistp384,ecdh-sha2-nistp521,diffie-hellman-group-exchange-sha256,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group14-sha256,diffie-hellman-group14-sha1
debug2: host key algorithms: ssh-rsa,rsa-sha2-512,rsa-sha2-256,ecdsa-sha2-nistp256,ssh-ed25519
debug2: ciphers ctos: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
debug2: ciphers stoc: chacha20-poly1305@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com
debug2: MACs ctos: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: MACs stoc: umac-64-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-256-etm@openssh.com,hmac-sha2-512-etm@openssh.com,hmac-sha1-etm@openssh.com,umac-64@openssh.com,umac-128@openssh.com,hmac-sha2-256,hmac-sha2-512,hmac-sha1
debug2: compression ctos: none,zlib@openssh.com
debug2: compression stoc: none,zlib@openssh.com
debug2: languages ctos: 
debug2: languages stoc: 
debug2: first_kex_follows 0 
debug2: reserved 0 
debug1: kex: algorithm: curve25519-sha256@libssh.org
debug1: kex: host key algorithm: ecdsa-sha2-nistp256
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug3: send packet: type 30
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug3: receive packet: type 31
debug1: Server host key: ecdsa-sha2-nistp256 SHA256:hcHb0w2X5IdOV2jn27jhqzaRlsafGmwvFRP4IEXWQlU
debug3: hostkeys_foreach: reading file "/root/.ssh/known_hosts"
debug3: record_hostkey: found key type ECDSA in file /root/.ssh/known_hosts:1
debug3: load_hostkeys: loaded 1 keys from 192.168.57.31
debug1: Host '192.168.57.31' is known and matches the ECDSA host key.
debug1: Found key in /root/.ssh/known_hosts:1
debug3: send packet: type 21
debug2: set_newkeys: mode 1
debug1: rekey after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug3: receive packet: type 21
debug1: SSH2_MSG_NEWKEYS received
debug2: set_newkeys: mode 0
debug1: rekey after 134217728 blocks
debug2: key: /root/.ssh/id_rsa (0x56316c5d8730)
debug2: key: /root/.ssh/id_dsa ((nil))
debug2: key: /root/.ssh/id_ecdsa ((nil))
debug2: key: /root/.ssh/id_ed25519 ((nil))
debug3: send packet: type 5
debug3: receive packet: type 7
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<ssh-ed25519,ssh-rsa,rsa-sha2-256,rsa-sha2-512,ssh-dss,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521>
debug3: receive packet: type 6
debug2: service_accept: ssh-userauth
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug3: send packet: type 50
debug3: receive packet: type 51
debug1: Authentications that can continue: publickey,password
debug3: start over, passed a different list publickey,password
debug3: preferred gssapi-keyex,gssapi-with-mic,publickey,keyboard-interactive,password
debug3: authmethod_lookup publickey
debug3: remaining preferred: keyboard-interactive,password
debug3: authmethod_is_enabled publickey
debug1: Next authentication method: publickey
debug1: Offering RSA public key: /root/.ssh/id_rsa
debug3: send_pubkey_test
debug3: send packet: type 50
debug2: we sent a publickey packet, wait for reply
debug3: receive packet: type 60
debug1: Server accepts key: pkalg rsa-sha2-512 blen 151
debug2: input_userauth_pk_ok: fp SHA256:3IwDVA+27KBSRRr/ZBjmGJcvh004VmLfWj4LQXxvi9A
debug3: sign_and_send_pubkey: RSA SHA256:3IwDVA+27KBSRRr/ZBjmGJcvh004VmLfWj4LQXxvi9A
debug3: send packet: type 50
debug3: receive packet: type 52
debug1: Authentication succeeded (publickey).
Authenticated to 192.168.57.31 ([192.168.57.31]:22).
debug1: channel 0: new [client-session]
debug3: ssh_session2_open: channel_new: 0
debug2: channel 0: send open
debug3: send packet: type 90
debug1: Requesting no-more-sessions@openssh.com
debug3: send packet: type 80
debug1: Entering interactive session.
debug1: pledge: network
debug3: receive packet: type 80
debug1: client_input_global_request: rtype hostkeys-00@openssh.com want_reply 0
debug3: receive packet: type 91
debug2: callback start
debug2: fd 3 setting TCP_NODELAY
debug3: ssh_packet_set_tos: set IP_TOS 0x10
debug2: client_session2_setup: id 0
debug2: channel 0: request pty-req confirm 1
debug3: send packet: type 98
debug1: Sending environment.
debug3: Ignored env SHELL
debug3: Ignored env TERM
debug3: Ignored env USER
debug3: Ignored env LS_COLORS
debug3: Ignored env MAIL
debug3: Ignored env PATH
debug3: Ignored env QT_QPA_PLATFORMTHEME
debug3: Ignored env PWD
debug1: Sending env LANG = ko_KR.UTF-8
debug2: channel 0: request env confirm 0
debug3: send packet: type 98
debug3: Ignored env SHLVL
debug3: Ignored env HOME
debug3: Ignored env LOGNAME
debug3: Ignored env XDG_DATA_DIRS
debug3: Ignored env LESSOPEN
debug3: Ignored env DISPLAY
debug3: Ignored env LESSCLOSE
debug3: Ignored env XAUTHORITY
debug3: Ignored env _
debug3: Ignored env OLDPWD
debug2: channel 0: request shell confirm 1
debug3: send packet: type 98
debug2: callback done
debug2: channel 0: open confirm rwindow 0 rmax 32768
debug3: receive packet: type 99
debug2: channel_input_status_confirm: type 99 id 0
debug2: PTY allocation request accepted on channel 0
debug2: channel 0: rcvd adjust 2097152
debug3: receive packet: type 99
debug2: channel_input_status_confirm: type 99 id 0
debug2: shell request accepted on channel 0
Welcome to Ubuntu 18.04.5 LTS (GNU/Linux 5.4.0-73-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

50 packages can be updated.
1 of these updates is a security update.
To see these additional updates run: apt list --upgradable

New release '20.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Your Hardware Enablement Stack (HWE) is supported until April 2023.
*** System restart required ***
Last login: Sat Aug 28 22:35:14 2021 from 192.168.57.5
root@ubuntu18:~# 

```



###  MTU, NAT, Firewall often behave badly in th presence of packet fragmentation



http://www.snailbook.com/faq/mtu-mismatch.auto.html

### Short Answer

You probably have an MTU/fragmentation problem. For each network interface on both client and server set the MTU to 576, eg `ifconfig eth0 mtu 576`. If the problem goes away, read on.

### Long Answer

Long answer: At each routing hop, IP packets bigger than the outgoing interface's Maximum Transmission Unit (MTU) get fragmented. Only the first fragment has TCP port numbers. Firewalls often behave badly in the presence of packet fragmentation, dropping everything but the first fragment since the subsequent ones can't be matched against the firewall rules. Some NAT configuration (eg many-to-one NAT or port address translation) can't match the fragments against their translation state tables.

Arguably, such devices should perform packet reassembly first so as to properly consider fragmented packets. However, this is more complicated and so is often not done. Also, this feature would raise a possible starvation attack against the packet filter, by sending many bogus initial fragments and causing the device to store them for reassembly with subsequent packets which will never come.

Logging in and using the shell will normally generate relatively small packets, and so the initial connection proceeds normally ; however if do you something that generates a lot of data (eg cat'ing a big file or starting an X Windows application), you may generate a packet bigger than the MTU.

Let's say it's a 1500 byte IP packet and the router has 2 different MTU's (say 1500 & 1484) and no firewall. When the router goes to forward it, the packet is too big for the interface MTU (1484), so the router breaks it into 2 fragments, 0 and 1. Fragment 0 contains the first 1484 bytes (including the TCP source and dest ports) and fragment 1 contains the remaining 16 bytes. Both fragments are sent on to their destinations.

When the first fragment reaches its target, it's held by the IP stack until the remaining fragments arrive, at which time the IP packet is reassembled and passed up the stack to TCP. If all fragments are not received by the timeout, the entire IP packet is discarded and an ICMP "timeout during reassembly" error is sent back.

Now add your firewall, which drops fragment 1. Your 1500 byte IP packet times out during reassembly and TCP retries, by sending another 1500 byte packet. Repeat. Eventually, TCP will time out and you'll get a connection termination.

IP stack parameters (such as Path MTU Discovery) and external variables (such as the MTU's of all the hops between hosts) can also affect whether or not a given connection will have this problem.