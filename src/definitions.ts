export interface PrinterPlugin {
  setupConnection(options: {ip: string, port: number}): Promise<{ status: string, payload: any }>;
  discover(options: { hops: number, waitForResponsesTimeout: number }): Promise<{ status: string, payload: any }>;
  health(): Promise<{ status: string, payload: any }>;
  print(options: { data: string }): Promise<{ status: string, payload: any }>;
}
