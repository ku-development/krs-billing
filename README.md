# KRS-Billing | V1.0 | Finished

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](link_to_releases)
[![License](https://img.shields.io/badge/license-GNU-green.svg)](https://opensource.org/licenses/MIT)
[![Issues](https://img.shields.io/github/issues/ku-development/krs-billing)](https://github.com/ku-development/krs-billing/issues)
[![Contributors](https://img.shields.io/github/contributors/ku-development/krs-billing)](none)

### Overview: 

Elevate your server’s job experience with **KRS-Billing**, an advanced billing system designed to enhance gameplay and streamline transactions. Our system features a unique, clean, and user-friendly interface, making it easy for workers to manage and issue bills with precision.

### **Key Features**

- **Intuitive Billing Interface:** Bill players effortlessly with configurable options or create custom bills by simply entering the reason and amount. The system allows for selecting multiple bills at once, providing flexibility and efficiency.

- **Anti-Trolling Measures:** Combat misuse with custom cooldowns between bills, Discord logs for each transaction, and a configurable maximum bill amount for each job. This ensures fair play and protects players from potential abuse.

- **Job Boss Management:** Empower job bosses with full access to all bills issued within their company. They can review, manage, and even refund bills, with the refunded amount being deducted from the society’s funds and returned to the player.

### **Why Choose KRS-Billing?**

In many servers, the billing systems are always boaring and ugly or just buggy and usless in this system the money will be taken and received to the boss menu directly...

## Exports

### Server-side:
```lua
exports['krs-billing']:BillPlayer(data)
```

### Client-side:
```lua
exports['krs-billing']:BillPlayer(data)
```

### Data Structure:
```lua
data = {
    biller = 'none',  -- 'none' indicates no specific biller; to set a real biller, input the biller’s CID
    receiver = 'none' -- receiver cid 
    reason = 'reason',
    amount = 555,
}
```


### Preview

![image](https://github.com/user-attachments/assets/0eb52971-fbcc-4468-b538-e80661ded8b3) 
![image](https://github.com/user-attachments/assets/9adb9620-ba1c-4208-950b-22617a3277c9)
![image](https://github.com/user-attachments/assets/9b338407-471d-44e1-b50e-690a90387584)
![image](https://github.com/user-attachments/assets/7b5ebd75-9c2e-472d-9dae-8d8040827e64)
![image](https://github.com/user-attachments/assets/bdc03201-9f2a-4b2a-acae-f0c8802563ad)
![image](https://github.com/user-attachments/assets/9040c7fc-8c8e-46de-8cac-6ecf4ad495d7)
![image](https://github.com/user-attachments/assets/32ac07fd-d1cd-4c1b-a51a-cc8db95d2c3f)
