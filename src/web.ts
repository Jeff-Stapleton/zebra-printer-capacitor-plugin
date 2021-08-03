/* eslint-disable @typescript-eslint/no-unused-vars */
import { WebPlugin } from '@capacitor/core';

import type { PrinterPlugin } from './definitions';

export class PrinterWeb extends WebPlugin implements PrinterPlugin {
  setupConnection(_options: { ip: string; port: number; }): Promise<{ status: string; payload: any; }> {
    throw new Error('Method not implemented.');
  }
  discover(_options: { hops: number; waitForResponsesTimeout: number; }): Promise<{ status: string; payload: any; }> {
    throw new Error('Method not implemented.');
  }
  health(): Promise<{ status: string; payload: any; }> {
    throw new Error('Method not implemented.');
  }
  print(_options: { data: string; }): Promise<{ status: string; payload: any; }> {
    throw new Error('Method not implemented.');
  }
  
}
