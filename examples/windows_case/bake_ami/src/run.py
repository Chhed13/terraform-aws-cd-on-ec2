import http.server
import socketserver
import os
import sys

with socketserver.TCPServer(("", 8000), http.server.SimpleHTTPRequestHandler) as httpd:
    if len(sys.argv) > 1: os.chdir(sys.argv[1])
    httpd.serve_forever()
