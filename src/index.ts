// Reexport the native module. On web, it will be resolved to HumeEviModule.web.ts
// and on native platforms to HumeEviModule.ts
export { default } from './HumeEviModule';
export { default as HumeEviView } from './HumeEviView';
export * from  './HumeEvi.types';
