new Vue({
    el: '#app',
    data: {
        Cid: '',
        view: 'myBills',
        showPlayerBills: false, 
        myBills: [],
        societyBills: [],
        billingHistory: [],
        players: [],
        newBill: {
            reason: '',
            amount: 0
        },
        nearbyPlayers: [],
        showBillDetails: false,
        selectedBill: {},
        selectedPlayer: null,
        loadingPlayers: false,
        searchQuery: '',
        selectedPlayerBills: []
    },
    computed: {
        filteredPlayers() {
            if (!this.searchQuery) return this.players;
            return this.players.filter(player =>
                player.name.toLowerCase().includes(this.searchQuery.toLowerCase()) ||
                player.cid.toLowerCase().includes(this.searchQuery.toLowerCase())
            );
        }
    },
    methods: {
        setView(view) {
            if (this.view !== view) {
                this.view = view;
                if (this.view === 'billPlayer') {
                    this.fetchNearbyPlayers().then(() => {
                        if (this.nearbyPlayers.length > 0) {
                            const randomIndex = Math.floor(Math.random() * this.nearbyPlayers.length);
                            this.selectedPlayer = this.nearbyPlayers[randomIndex];
                        }
                    });
                }
            }
        },
        billPlayer() {
            fetch(`https://${GetParentResourceName()}/krs-billing:callback:billPlayer`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    cid: this.Cid,
                    reason: this.newBill.reason,
                    amount: this.newBill.amount,
                    targetCid: this.selectedPlayer.cid
                })
            }).then(resp => resp.json()).then(resp => {
                if (resp === 'ok') {
                    this.newBill.reason = '';
                    this.newBill.amount = 0;
                    this.selectedPlayer = null;
                } else {
                    this.$notify({ title: 'Error', message: 'Failed to bill the player', type: 'error' });
                }
            });
        },
        refundBill(billId) {
            fetch(`https://${GetParentResourceName()}/krs-billing:callback:refundBill`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ billId: billId })
            }).then(response => response.json()).then(resp => {
                if (resp === 'ok') {
                    this.$notify({ title: 'Success', message: 'Bill refunded successfully', type: 'success' });
                } else {
                    this.$notify({ title: 'Error', message: 'Failed to refund the bill', type: 'error' });
                }
            });
        },
        showDetails(bill) {
            this.selectedBill = bill;
            this.showBillDetails = true;
        },
        closeDetails() {
            this.showBillDetails = false;
        },
        markAsPaid(billId) {
            const bill = this.myBills.find(bill => bill.id === billId);
            if (bill) {
                fetch(`https://${GetParentResourceName()}/krs-billing:callback:payBill`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify({
                        billId: billId,
                        payFromJobAccount: false
                    })
                }).then(response => response.json()).then(resp => {
                    if (resp === 'ok') {
                        bill.paid = true;
                        this.myBills = this.myBills.filter(bill => bill.id !== billId);
                        this.billingHistory.push(bill);
                        this.closeDetails();
                    } else {
                        this.$notify({ title: 'Error', message: 'Failed to pay the bill', type: 'error' });
                    }
                });
            }
        },
        fetchNearbyPlayers() {
            this.loadingPlayers = true;
            fetch(`https://${GetParentResourceName()}/krs-billing:callback:getNearbyPlayers`)
                .then(response => response.json())
                .then(players => {
                    this.nearbyPlayers = players;
                    this.loadingPlayers = false;
                });
        },
        closeUI() {
            this.setView('myBills');
            fetch(`https://${GetParentResourceName()}/krs-billing:callback:close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            }).then(() => {
                SetNuiFocus(false, false); 
            });
        }
    },
    mounted() {
        window.addEventListener('message', (event) => {
            if (event.data.type === 'openMe') {
                const data = event.data.data;
                
                this.Cid = data.cid;
                this.myBills = data.myBills;
                this.societyBills = data.societyBills;
                this.billingHistory = data.billingHistory;

                if (data.jobAccess) {
                    this.showPlayerBills = true;
                } else {
                    this.showPlayerBills = false;
                }

                this.setView('myBills');
            }
        });
    }
});
