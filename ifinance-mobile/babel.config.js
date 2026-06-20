module.exports = function (api) {
  api.cache(true);
  // babel-preset-expo (SDK 50+) resolves the "@/*" alias from tsconfig "paths"
  // natively, so no module-resolver plugin is needed here.
  return {
    presets: ['babel-preset-expo'],
  };
};
