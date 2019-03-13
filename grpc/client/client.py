# Copyright 2015 gRPC authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
"""The Python implementation of the GRPC helloworld.Greeter client."""

from __future__ import print_function
from argparse import ArgumentParser

import grpc

import helloworld_pb2
import helloworld_pb2_grpc

parser = ArgumentParser()
parser.add_argument("--channel", help="REQURIED: ip:port of backend")
parser.add_argument("--tls", help="uses TLS version of client", action="store_true")
parser.add_argument("--message", help="message sent to the gRPC server")

args = parser.parse_args()

if args.message:
    message = args.message
else:
    message = 'Hello World!'


def run():
    # NOTE(gRPC Python Team): .close() is possible on a channel and should be
    # used in circumstances in which the with statement does not fit the needs
    # of the code.

    if args.tls:
        # roots.pem contains valid root certs for most CAs and is required tls handshake
        # copied from gRPC repo https://github.com/grpc/grpc/blob/master/etc/roots.pem
        # f = open('certs/server.crt', 'rb')
        creds = grpc.ssl_channel_credentials()
        channel = grpc.secure_channel(args.channel, creds)
    else:
        channel = grpc.insecure_channel(args.channel)
    stub = helloworld_pb2_grpc.GreeterStub(channel)
    response = stub.SayHello(helloworld_pb2.HelloRequest(name=message))
    print("Request: " + message)
    print("Response: " + response.message)


if __name__ == '__main__':
    run()
