import { requireNativeView } from 'expo';
import * as React from 'react';

import { HumeEviViewProps } from './HumeEvi.types';

const NativeView: React.ComponentType<HumeEviViewProps> =
  requireNativeView('HumeEvi');

export default function HumeEviView(props: HumeEviViewProps) {
  return <NativeView {...props} />;
}
