# haskell-language-server.nix

> Improve Haskell Language Server hacking experience with a local Hoogle server.

## Background

When hacking on Haskell Language Server, Hoogle is an essential resource. However, if you've
ever tried searching for types in key dependencies such as `lsp-types` you might have 
noticed that many are missing (like `CodeAction`). Then you're stuck searching source code.

This project aims to address this by providing a local Hoogle instance with _everything_ from
dependencies, including the missing generated types.

## Dependencies

Before getting started, you'll need the following dependencies

 * Nix
 * direnv (optional)

## Usage

To build the hoogle index and launch a local server, run:

    nix develop github:sgillespie/haskell-language-server.nix#ghc912 \
        --command hoogle server --local --port 8000

## Acknowledgements

This project is built on the following tools and ecosystems:

 * [Hoogle](https://github.com/ndmitchell/hoogle): Haskell documentation search engine
 * [haskell.nix](https://github.com/input-output-hk/haskell.nix): Deterministic builds and hoogle integration
 * [Haskell Language Server](https://github.com/haskell/haskell-language-server): Official Haskell LSP implementation

## License

Licensed under Apache 2.0 License, see [LICENSE](LICENSE).


