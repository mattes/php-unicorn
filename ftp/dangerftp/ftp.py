#!/usr/bin/env python

import os
from pyftpdlib.handlers import FTPHandler
from pyftpdlib.servers import FTPServer
from pyftpdlib.authorizers import DummyAuthorizer

class UsernameIsPathAuthorizer(DummyAuthorizer):

    def validate_authentication(self, username, password, handler):
        if not username in self.user_table:
            handler.authorizer.add_user(username, "", os.path.join(os.getenv('FTP_ROOT', ''), username), perm="elradfmw")
        return True

def main():
    authorizer = UsernameIsPathAuthorizer()
    authorizer.add_anonymous("/")

    handler = FTPHandler
    handler.authorizer = authorizer
    server = FTPServer(('*', 2121), handler)
    server.serve_forever()

if __name__ == "__main__":
    main()