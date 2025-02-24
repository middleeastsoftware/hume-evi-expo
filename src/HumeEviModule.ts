import { NativeModule, requireNativeModule } from 'expo';

import { HumeEviModuleEvents } from './HumeEvi.types';

declare class HumeEviModule extends NativeModule<HumeEviModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
}

// This call loads the native module object from the JSI.
export default requireNativeModule<HumeEviModule>('HumeEvi');
