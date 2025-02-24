import { registerWebModule, NativeModule } from 'expo';

import { HumeEviModuleEvents } from './HumeEvi.types';

class HumeEviModule extends NativeModule<HumeEviModuleEvents> {
  PI = Math.PI;
  async setValueAsync(value: string): Promise<void> {
    this.emit('onChange', { value });
  }
  hello() {
    return 'Hello world! 👋';
  }
}

export default registerWebModule(HumeEviModule);
