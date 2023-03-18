#!/usr/bin/env python
# coding: utf-8 -*-

import os
import socket
import struct
import sys
import threading
import time
import urllib

try:
    from SimpleHTTPServer import SimpleHTTPRequestHandler
    from SocketServer import TCPServer
    from urllib import quote
    from urlparse import urlparse
except ImportError:
    from http.server import SimpleHTTPRequestHandler
    from socketserver import TCPServer
    from urllib.parse import quote
    from urllib.parse import urlparse

hostPort = 8080  # Default value
iinput = sys.argv[3]
target_ip = sys.argv[2]
mode = int(sys.argv[1])
hostIp = [(s.connect(('8.8.8.8', 53)), s.getsockname()[0], s.close())
          for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]
hostPort = 8080  # Default

print(mode == 1)
if (mode == 1):
    baseUrl = hostIp + ':' + str(hostPort) + '/'
    if os.path.isfile(iinput):
            file_list_payload = baseUrl + quote(os.path.basename(iinput))
            directory = os.path.dirname(iinput)  # get file directory
    else:
        directory = iinput  # it's a directory
        file_list_payload = ''  # init the payload before adding lines
        for file in [file for file in next(os.walk(iinput))[2]]:
            file_list_payload += baseUrl + quote(file) + '\n'

            if len(file_list_payload) == 0:
                sys.exit(1)

    file_list_payloadBytes = file_list_payload.encode('ascii')
    if directory and directory != '.':  # doesn't need to move if it's already the current working directory
        # set working directory to the right folder to be able to serve files
        os.chdir(directory)

    class MyServer(TCPServer):
        def server_bind(self):
            import socket
            self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
            self.socket.bind(self.server_address)

    server = MyServer(('', hostPort), SimpleHTTPRequestHandler)
    thread = threading.Thread(target=server.serve_forever)
    thread.start()

    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((target_ip, 5000))
        sock.sendall(struct.pack('!L', len(file_list_payloadBytes)) + file_list_payloadBytes)
        while len(sock.recv(1)) < 1:
            time.sleep(0.05)
            sock.close()
    except Exception as e:
        server.shutdown()
        sys.exit(1)
    server.shutdown()

else:
    try:
        from urlparse import urlparse
    except ImportError:
        from urllib.parse import urlparse

    if len(sys.argv) < 3:
        sys.exit(1)

    target_ip = sys.argv[2]
    file_list_payload = ''

    for url in sys.argv[3:]:
        parsed = urlparse(url)
        if not parsed.scheme in ('http', 'https') or parsed.netloc == '':
            sys.exit(1)

    file_list_payload += url + '\n'

    file_list_payloadBytes = file_list_payload.encode('ascii')

    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.connect((target_ip, 5000))
        sock.sendall(struct.pack('!L', len(file_list_payloadBytes)) + file_list_payloadBytes)
        while len(sock.recv(1)) < 1:
            time.sleep(0.05)
            sock.close()
    except Exception as e:
        sys.exit(1)
