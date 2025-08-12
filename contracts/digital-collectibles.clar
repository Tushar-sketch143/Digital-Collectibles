;; Digital Collectibles Contract
;; A minimal NFT-style implementation with only two functions

;; Import SIP-009 non-fungible token trait
(define-non-fungible-token digital-collectible uint)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-minted (err u101))
(define-constant err-not-owner (err u102))

;; Track next collectible ID
(define-data-var next-id uint u1)

;; 1. Mint a new collectible (only contract owner)
(define-public (mint (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (let ((token-id (var-get next-id)))
      (try! (nft-mint? digital-collectible token-id recipient))
      (var-set next-id (+ token-id u1))
      (ok token-id)
    )
  )
)

;; 2. Transfer collectible to another user
(define-public (transfer (token-id uint) (recipient principal))
  (begin
    (asserts! (is-eq (nft-get-owner? digital-collectible token-id) (some tx-sender)) err-not-owner)
    (try! (nft-transfer? digital-collectible token-id tx-sender recipient))
    (ok true)
  )
)
