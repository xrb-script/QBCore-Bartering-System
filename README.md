# QB/QBOX xrb-Bartering
https://youtu.be/f1IoP2nJQMQ?si=kR70_Dr21twZ6Qt6

* **Tiered Contract System:** 
Players interact with a dynamic Contractor NPC (`ox_target`) to receive contracts whose difficulty and rewards scale based on the player's earned "Bartering Points".

* **Point-Based Progression:** 
Successfully completing contracts (delivering required items within a time limit) primarily rewards Bartering Points, which are used to progress and unlock shop access.

* **Configurable Rewards:** 
Contracts also offer secondary rewards like cash, bank money, or specific items (e.g., configurable black money item like `black_money`).

* **Exclusive Shops (ox_lib UI):** 
Players spend their Bartering Points to gain access to dedicated shop NPCs, which open an `ox_lib` menu interface displaying items for purchase.

* **Randomized & Refreshing Stock:** 
Shop inventories are populated randomly based on configured chances and stock ranges (`Config.Shops`) and refresh automatically at a set interval (or via admin command).

* **Cancel Streak Penalty:** 
Canceling contracts incurs a point penalty that *doubles* for each consecutive cancellation (up to a configurable limit), encouraging players to commit. This streak resets on successful contract completion.

* **Status Check (`/bartering`):** 
Players can use the `/bartering` command to open an `ox_lib` menu showing their current points and details of their active contract (time left, reward points, required items).

* **Admin Management** (`/adminbartering`):
Admins (with the configured permission group) can use this command to open an `ox_lib` menu listing online players, allowing them to add, remove, or set Bartering Points for individuals. Admin actions are logged to the server console.)
