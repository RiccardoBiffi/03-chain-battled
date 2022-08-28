# Mutable NFTs

This week's project is about creating NFTs that "evolve" according to some logic.

A "warrior" NFT is created with some stats (level, HP, strength, speed) and those are visible on its image.
Moreover you can train the NFT so that its stats randomly improve. Then the image changes by reflecting the new stats.

We do not use IPFS to store the image nor the metadata, it is all deployed on chain! Therefore the smart contract has complete control over the NFT's image and metadata.
The image is created as an SVG and then converted to Base64 format. The browser knows how do display Base64 images and we can manage them in Solidity as strings.

The contract is deployed on Polygon to save gas fees because deploying everything on chain is costly.