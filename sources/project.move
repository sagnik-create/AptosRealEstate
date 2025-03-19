module MyModule::VirtualRealEstate {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a virtual land listing.
    struct Land has store, key {
        price: u64,  // Price of the land in Aptos tokens
        owner: address, // Owner of the land
    }

    /// Function to list a virtual land for sale.
    public fun list_land(seller: &signer, price: u64) {
        let land = Land {
            price,
            owner: signer::address_of(seller),
        };
        move_to(seller, land);
    }

    /// Function to buy a listed virtual land.
    public fun buy_land(buyer: &signer, seller: address) acquires Land {
        let land = borrow_global_mut<Land>(seller);

        // Transfer the payment from the buyer to the seller
        let payment = coin::withdraw<AptosCoin>(buyer, land.price);
        coin::deposit<AptosCoin>(seller, payment);

        // Transfer ownership
        land.owner = signer::address_of(buyer);
    }
}
