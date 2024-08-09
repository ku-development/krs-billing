Vue.component('v-select', VueSelect.VueSelect);

new Vue({
    el: '#app',
    data: {
        view: 'myBills',
        showPlayerBills: false, 

        myBills: [
            { id: 1, amount: 100, reason: 'Service Fee', sender: 'Company A', billedBy: { name: 'John Doe', job: 'Mechanic' }, date: '2024-08-09', time: '14:30', paid: false },
            { id: 2, amount: 250, reason: 'Product Purchase', sender: 'Company B', billedBy: { name: 'Jane Smith', job: 'Sales' }, date: '2024-08-08', time: '09:15', paid: false },
            { id: 3, amount: 300, reason: 'Consultation', sender: 'Company C', billedBy: { name: 'Mike Johnson', job: 'Consultant' }, date: '2024-08-07', time: '11:00', paid: false },
            { id: 4, amount: 150, reason: 'Software License', sender: 'Company D', billedBy: { name: 'Emily Davis', job: 'IT' }, date: '2024-08-06', time: '16:45', paid: false }
        ],
        societyBills: [
            { id: 1, amount: 500, reason: 'Repair Service', sender: 'Worker A', billedBy: { name: 'Alex Brown', job: 'Repairman' }, date: '2024-08-05', time: '13:20' },
            { id: 2, amount: 1500, reason: 'Monthly Subscription', sender: 'Worker B', billedBy: { name: 'Sophia Wilson', job: 'Manager' }, date: '2024-08-04', time: '10:00' }
        ],
        billingHistory: [
            { id: 5, amount: 250, reason: 'Product Purchase', sender: 'Company B', billedBy: { name: 'Jane Smith', job: 'Sales' }, date: '2024-08-08', time: '09:15', paid: true },
            { id: 6, amount: 150, reason: 'Software License', sender: 'Company D', billedBy: { name: 'Emily Davis', job: 'IT' }, date: '2024-08-06', time: '16:45', paid: true }
        ],
        players: [
            {
                name: "John Doe",
                cid: "12345",
                job: "Mechanic",
                bills: [
                    {
                        id: 1,
                        amount: 100,
                        reason: 'Service Fee',
                        date: '2024-08-09',
                        paid: false,
                        billedBy: {
                            name: 'David Clark', job: 'IT Manager'
                        }
                    },
                    {
                        id: 3,
                        amount: 300,
                        reason: 'Consultation',
                        date: '2024-08-07',
                        paid: false,
                        billedBy: {
                            name: 'David Clark', job: 'IT Manager'
                        }
                    }
                ],
                billingHistory: [
                    {
                        id: 5,
                        amount: 250,
                        reason: 'Product Purchase',
                        date: '2024-08-08',
                        paid: true,
                        billedBy: {
                            name: 'David Clark', job: 'IT Manager'
                        }
                    }
                ]
            },
            {
                name: "Jane Smith",
                cid: "67890",
                job: "Sales",
                bills: [
                    {
                        id: 2,
                        amount: 250,
                        reason: 'Product Purchase',
                        date: '2024-08-08',
                        paid: false,
                        billedBy: {
                            name: 'David Clark', job: 'IT Manager'
                        }
                    },
                    {
                        id: 4,
                        amount: 150,
                        reason: 'Software License',
                        date: '2024-08-06',
                        paid: false,
                        billedBy: {
                            name: 'David Clark', job: 'IT Manager'
                        }
                    }
                ],
                billingHistory: [
                    {
                        id: 6,
                        amount: 150,
                        reason: 'Software License',
                        date: '2024-08-06',
                        paid: true,
                        billedBy: {
                            name: 'David Clark', job: 'IT Manager'
                        }
                    }
                ]
            },
            {
                name: "Mike Johnson",
                cid: "11223",
                job: "Consultant",
                bills: [],
                billingHistory: []
            },
            {
                name: "Mike Johnson",
                cid: "11223",
                job: "Consultant",
                bills: [],
                billingHistory: []
            },
            {
                name: "Mike Johnson",
                cid: "11223",
                job: "Consultant",
                bills: [],
                billingHistory: []
            },    {
                name: "Mike Johnson",
                cid: "11223",
                job: "Consultant",
                bills: [],
                billingHistory: []
            },
        ],
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
        selectedPlayerBills: [],
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
            console.log('Billing player with reason:', this.newBill.reason, 'and amount:', this.newBill.amount);
            this.newBill.reason = '';
            this.newBill.amount = 0;
        },
        refundBill(billId) {
            console.log('Refunding bill with id:', billId);
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
                bill.paid = true;
                this.myBills = this.myBills.filter(bill => bill.id !== billId);
                this.billingHistory.push(bill); 
            }
            this.closeDetails();
        },
        async fetchNearbyPlayers() {
            this.loadingPlayers = true;
            await new Promise(resolve => setTimeout(resolve, 1000));
            this.nearbyPlayers = this.players;
            this.loadingPlayers = false;
        },
        billPlayer() {
            if (!this.selectedPlayer) {
                alert('Please select a player');
                return;
            }
            console.log('Billing player:', this.selectedPlayer.name);
            console.log('Reason:', this.newBill.reason);
            console.log('Amount:', this.newBill.amount);

            this.selectedPlayer = null;
            this.newBill.reason = '';
            this.newBill.amount = 0;
        },
        selectPlayerForInspection(player) {
            this.selectedPlayer = player;
            this.selectedPlayerBills = [...player.bills, ...player.billingHistory];
        },
        selectPlayerForInspection(player) {
            this.selectedPlayer = player;
            this.selectedPlayerBills = [...player.bills, ...player.billingHistory];
            this.showPlayerBills = true; 
        },
        closePlayerBills() {
            this.showPlayerBills = false; 
        }
    },
});
