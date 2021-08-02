export interface PrinterPlugin {
  health(options: { ip: string, port: number}): Promise<{ success: boolean }>;
  print(options: { ip: string, port: number, data: string }): Promise<{ success: boolean }>;
  discover(options: { hops: number }): Promise<{ addresses: any[] }>;
}
