import http.server
import socketserver

PORT = 8004

class CGIRequestHandler(http.server.CGIHTTPRequestHandler):
    cgi_directories = ["/cgi-bin"]  # Указываем каталог для CGI-скриптов

# Запуск сервера
with socketserver.TCPServer(("", PORT), CGIRequestHandler) as httpd:
    print(f"Server running at http://localhost:{PORT}/")
    httpd.serve_forever()