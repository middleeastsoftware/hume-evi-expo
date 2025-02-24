import * as React from 'react';

import { HumeEviViewProps } from './HumeEvi.types';

export default function HumeEviView(props: HumeEviViewProps) {
  return (
    <div>
      <iframe
        style={{ flex: 1 }}
        src={props.url}
        onLoad={() => props.onLoad({ nativeEvent: { url: props.url } })}
      />
    </div>
  );
}
