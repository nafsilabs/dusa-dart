class Env {
  static const grpcBuildnetHost = String.fromEnvironment(
    'grpc_buildnet_host',
    defaultValue: 'buildnet.massa.net',
    //defaultValue: 'mainnet.massa.net',
  );
  static const grpcMainnetHost = String.fromEnvironment(
    'grpc_mainnet_host',
    defaultValue: 'mainnet.massa.net',
  );
  static const grpcPort = int.fromEnvironment(
    'grpc_port',
    defaultValue: 33037,
  );

  static const jrpcHost = String.fromEnvironment(
    'jrpc_host',
    defaultValue: 'mainnet.massa.net',
  );
  static const jrpcVersion = String.fromEnvironment(
    'jrpc_port',
    defaultValue: "api/v2",
  );

  /// privateKey should be kept private. But this key is here for experimenting and never use it.
  /// its corresponding public key: P16CaSWoXu5A3AVTynHZH4BP8rkd1GNuSvwxMwWpJZwNcYmamww
  /// its correspoding address:    AU1y3oYTgK8RGzLWFVAGL3JxHLdTVKxBPHrwbo2Kj8a2CSbeMug
  static const privateKey = String.fromEnvironment(
    'privateKey',
    defaultValue:
        "S1R3W8t9tRBxxRsULe2cLJXX1moAragCzKh8gVxB8PBLJdA4vCD", //this private key is used for testing only. Never use it as it is publicly avaiable.
  );
}
