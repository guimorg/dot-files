// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.


module.exports = {
  plugins: [
    // "hyper-font-ligatures",
    "hyper-one-dark",
    "hyper-search",
    "hyper-pane",
    "hypercwd",
    "hyper-active-tab",
    "hyperline",
  ],
  config: {
    // choose either `'stable'` for receiving highly polished,
    // or `'canary'` for less polished but more frequent updates
    updateChannel: 'stable',
    shell: '/bin/zsh',

    activeTab: '🚀',

    // default font size in pixels for all tabs
    fontSize: 13,

    // font family with optional fallbacks
    fontFamily: '"Fira Code", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',

    // default font weight: 'normal' or 'bold'
    fontWeight: 'normal',
    
    // rest of the config
    webGLRenderer: false,
  }
  // rest of the file
}
