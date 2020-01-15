
```bash
❯❯❯ echo $ALICE_ADDRESS
tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
```

```haskell
import qualified Lorentz.Contracts.ManagedLedger.Specialized as MLS

*Main MLS> printLorentzContract True $  MLS.specializedManagedLedgerContract "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr"
"parameter (or (or (pair %transfer (address :from) (pair (address :to) (nat :value))) (or (pair %getBalance (address :owner) (contract nat)) (pair %getTotalSupply unit (contract nat)))) (or (pair %getAdministrator unit (contract address)) (or (pair %mint (address :to) (nat :value)) (pair %burn (address :from) (nat :value)))));storage (pair (big_map address nat) nat);code { CAST (pair (or (or (pair address (pair address nat)) (or (pair address (contract nat)) (pair unit (contract nat)))) (or (pair unit (contract address)) (or (pair address nat) (pair address nat)))) (pair (big_map address nat) nat));DUP;CAR;DIP { CDR };IF_LEFT { IF_LEFT { DUP;DUP;CDR;CAR;DIP { CAR };COMPARE;EQ;IF { DROP }   { DIP { DUP };SWAP;DIP { DUP };SWAP;CDR;CAR;DIP { CAR };GET;IF_NONE { DUP;CDR;CDR;INT;EQ;IF { NONE nat }   { DUP;CDR;CDR;SOME } }        { DIP { DUP };SWAP;CDR;CDR;ADD;SOME };SWAP;DUP;DIP { CDR;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;CDR;INT;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { CDR;CDR;PUSH nat 0;SWAP;PAIR;PUSH string \"NotEnoughBalance\";PAIR;FAILWITH }        {  };DIP { DUP;CDR;CDR };SWAP;SUB;ISNAT;IF_NONE { PUSH string \"insufficient balance\";PAIR;FAILWITH }        {  };DIP { DUP };SWAP;DIP { DUP;INT;EQ;IF { DROP;NONE nat }   { SOME };SWAP;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;CDR;NEG;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP };NIL operation;PAIR }        { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };DIP { CAR };GET;IF_NONE { PUSH nat 0 }        {  };DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;CDR;CDR;DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR } } }        { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DROP;PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { IF_LEFT { PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { DUP;CDR;INT;EQ;IF { NONE nat }   { DUP;CDR;SOME } }        { DIP { DUP };SWAP;CDR;ADD;SOME };SWAP;DUP;DIP { CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;INT;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR }        { PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { CDR;PUSH nat 0;SWAP;PAIR;PUSH string \"NotEnoughBalance\";PAIR;FAILWITH }        {  };DIP { DUP;CDR };SWAP;SUB;ISNAT;IF_NONE { PUSH string \"insufficient balance\";PAIR;FAILWITH }        {  };DIP { DUP };SWAP;DIP { DUP;INT;EQ;IF { DROP;NONE nat }   { SOME };SWAP;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;NEG;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR } } } };"
```

```bash
❯❯❯ alpha-client --wait none originate contract SpecializedManagedLedger \
  transferring 0 from $ALICE_ADDRESS running \
  "parameter (or (or (pair %transfer (address :from) (pair (address :to) (nat :value))) (or (pair %getBalance (address :owner) (contract nat)) (pair %getTotalSupply unit (contract nat)))) (or (pair %getAdministrator unit (contract address)) (or (pair %mint (address :to) (nat :value)) (pair %burn (address :from) (nat :value)))));storage (pair (big_map address nat) nat);code { CAST (pair (or (or (pair address (pair address nat)) (or (pair address (contract nat)) (pair unit (contract nat)))) (or (pair unit (contract address)) (or (pair address nat) (pair address nat)))) (pair (big_map address nat) nat));DUP;CAR;DIP { CDR };IF_LEFT { IF_LEFT { DUP;DUP;CDR;CAR;DIP { CAR };COMPARE;EQ;IF { DROP }   { DIP { DUP };SWAP;DIP { DUP };SWAP;CDR;CAR;DIP { CAR };GET;IF_NONE { DUP;CDR;CDR;INT;EQ;IF { NONE nat }   { DUP;CDR;CDR;SOME } }        { DIP { DUP };SWAP;CDR;CDR;ADD;SOME };SWAP;DUP;DIP { CDR;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;CDR;INT;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { CDR;CDR;PUSH nat 0;SWAP;PAIR;PUSH string \"NotEnoughBalance\";PAIR;FAILWITH }        {  };DUP;DIP { SWAP };DIP { DUP;CDR;CDR };SWAP;SUB;ISNAT;DIP { SWAP };IF_NONE { PAIR;PUSH string \"insufficient balance\";PAIR;FAILWITH }        { DIP { DROP } };DIP { DUP };SWAP;DIP { DUP;INT;EQ;IF { DROP;NONE nat }   { SOME };SWAP;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;CDR;NEG;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP };NIL operation;PAIR }        { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };DIP { CAR };GET;IF_NONE { PUSH nat 0 }        {  };DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;CDR;CDR;DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR } } }        { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DROP;PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { IF_LEFT { PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { DUP;CDR;INT;EQ;IF { NONE nat }   { DUP;CDR;SOME } }        { DIP { DUP };SWAP;CDR;ADD;SOME };SWAP;DUP;DIP { CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;INT;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR }        { PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { CDR;PUSH nat 0;SWAP;PAIR;PUSH string \"NotEnoughBalance\";PAIR;FAILWITH }        {  };DUP;DIP { SWAP };DIP { DUP;CDR };SWAP;SUB;ISNAT;DIP { SWAP };IF_NONE { PAIR;PUSH string \"insufficient balance\";PAIR;FAILWITH }        { DIP { DROP } };DIP { DUP };SWAP;DIP { DUP;INT;EQ;IF { DROP;NONE nat }   { SOME };SWAP;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;NEG;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR } } } };" \
  --init "Pair { } 0" --burn-cap 2.464

Waiting for the node to be bootstrapped before injection...
Current head: BKj4i8rhZSSa (timestamp: 2020-01-13T22:02:30-00:00, validation: 2020-01-13T22:02:34-00:00)
Node is bootstrapped, ready for injecting operations.
Estimated gas: 54551 units (will add 100 for safety)
Estimated storage: 2054 bytes added (will add 20 for safety)
Operation successfully injected in the node.
Operation hash is 'ooSssM5n6p1hxyG5pCPQKnxNeVoWtRAZyuuuLBX8yKoa9tRoUSV'
NOT waiting for the operation to be included.
Use command
  tezos-client wait for ooSssM5n6p1hxyG5pCPQKnxNeVoWtRAZyuuuLBX8yKoa9tRoUSV to be included --confirmations 30 --branch BKj4i8rhZSSaTp386PXYQcHaB34FU9hDLNRxinnevr31aeyXcWi
and/or an external block explorer to make sure that it has been included.
This sequence of operations was run:
  Manager signed operations:
    From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
    Fee to the baker: ꜩ0.007462
    Expected counter: 84645
    Gas limit: 54651
    Storage limit: 2074 bytes
    Balance updates:
      tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ............. -ꜩ0.007462
      fees(tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU,102) ... +ꜩ0.007462
    Origination:
      From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
      Credit: ꜩ0
      Script:
        { parameter
            (or (or (pair %transfer (address :from) (pair (address :to) (nat :value)))
                    (or (pair %getBalance (address :owner) (contract nat))
                        (pair %getTotalSupply unit (contract nat))))
                (or (pair %getAdministrator unit (contract address))
                    (or (pair %mint (address :to) (nat :value)) (pair %burn (address :from) (nat :value))))) ;
          storage (pair (big_map address nat) nat) ;
          code { CAST (pair (or (or (pair address (pair address nat))
                                    (or (pair address (contract nat)) (pair unit (contract nat))))
                                (or (pair unit (contract address)) (or (pair address nat) (pair address nat))))
                            (pair (big_map address nat) nat)) ;
                 DUP ;
                 CAR ;
                 DIP { CDR } ;
                 IF_LEFT
                   { IF_LEFT
                       { DUP ;
                         DUP ;
                         CDR ;
                         CAR ;
                         DIP { CAR } ;
                         COMPARE ;
                         EQ ;
                         IF { DROP }
                            { DUP ;
                              CAR ;
                              DIP { CDR } ;
                              DIP { DIP {} ;
                                    DUP ;
                                    CAR ;
                                    DIP { CDR } ;
                                    SWAP ;
                                    DIP { DIP { DUP ; CAR ; DIP { CDR } ; DUP } ;
                                          DUP ;
                                          DIP { GET ; IF_NONE { PUSH nat 0 } {} } } ;
                                    DUP ;
                                    DIP { SWAP ; DIP { ADD ; SOME } ; UPDATE } } ;
                              SWAP ;
                              DIP { DIP { DUP } ;
                                    DUP ;
                                    DIP { GET ; IF_NONE { PUSH string "from missing" ; FAILWITH } {} } ;
                                    SWAP } ;
                              SWAP ;
                              SUB ;
                              ISNAT ;
                              IF_NONE { PUSH string "insufficient balance" ; FAILWITH } { SOME } ;
                              SWAP ;
                              UPDATE ;
                              PAIR } ;
                         NIL operation ;
                         PAIR }
                       { IF_LEFT
                           { DUP ;
                             CAR ;
                             DIP { CDR } ;
                             DIP { DIP { DUP } ; SWAP } ;
                             PAIR ;
                             DUP ;
                             CAR ;
                             DIP { CDR } ;
                             DIP { CAR } ;
                             GET ;
                             IF_NONE { PUSH nat 0 } {} ;
                             DIP { AMOUNT } ;
                             TRANSFER_TOKENS ;
                             NIL operation ;
                             SWAP ;
                             CONS ;
                             PAIR }
                           { DUP ;
                             CAR ;
                             DIP { CDR } ;
                             DIP { DIP { DUP } ; SWAP } ;
                             PAIR ;
                             CDR ;
                             CDR ;
                             DIP { AMOUNT } ;
                             TRANSFER_TOKENS ;
                             NIL operation ;
                             SWAP ;
                             CONS ;
                             PAIR } } }
                   { IF_LEFT
                       { DUP ;
                         CAR ;
                         DIP { CDR } ;
                         DIP { DIP { DUP } ; SWAP } ;
                         PAIR ;
                         DROP ;
                         PUSH address "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr" ;
                         DIP { AMOUNT } ;
                         TRANSFER_TOKENS ;
                         NIL operation ;
                         SWAP ;
                         CONS ;
                         PAIR }
                       { IF_LEFT
                           { PUSH address "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr" ;
                             SENDER ;
                             COMPARE ;
                             EQ ;
                             IF {} { UNIT ; PUSH string "SenderIsNotAdmin" ; PAIR ; FAILWITH } ;
                             DIP { DUP } ;
                             SWAP ;
                             DIP { DUP } ;
                             SWAP ;
                             CAR ;
                             DIP { CAR } ;
                             GET ;
                             IF_NONE
                               { DUP ; CDR ; INT ; EQ ; IF { NONE nat } { DUP ; CDR ; SOME } }
                               { DIP { DUP } ; SWAP ; CDR ; ADD ; SOME } ;
                             SWAP ;
                             DUP ;
                             DIP { CAR ; DIP { DIP { DUP ; CAR ; DIP { CDR } } } ; UPDATE ; PAIR } ;
                             DUP ;
                             DIP { CDR ;
                                   INT ;
                                   DIP { DUP ; CDR } ;
                                   ADD ;
                                   ISNAT ;
                                   IF_NONE { PUSH string "Internal: Negative total supply" ; FAILWITH } {} ;
                                   DIP { DUP ; DIP { CAR } ; CDR } ;
                                   DIP { DROP } ;
                                   SWAP ;
                                   PAIR } ;
                             DROP ;
                             NIL operation ;
                             PAIR }
                           { PUSH address "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr" ;
                             SENDER ;
                             COMPARE ;
                             EQ ;
                             IF {} { UNIT ; PUSH string "SenderIsNotAdmin" ; PAIR ; FAILWITH } ;
                             DIP { DUP } ;
                             SWAP ;
                             DIP { DUP } ;
                             SWAP ;
                             CAR ;
                             DIP { CAR } ;
                             GET ;
                             IF_NONE
                               { CDR ;
                                 PUSH nat 0 ;
                                 SWAP ;
                                 PAIR ;
                                 PUSH string "NotEnoughBalance" ;
                                 PAIR ;
                                 FAILWITH }
                               {} ;
                             DUP ;
                             DIP { SWAP ; DUP ; CDR } ;
                             SUB ;
                             ISNAT ;
                             DIP { SWAP } ;
                             IF_NONE
                               { PAIR ; PUSH string "insufficient balance" ; PAIR ; FAILWITH }
                               { DIP { DROP } } ;
                             DIP { DUP } ;
                             SWAP ;
                             DIP { DUP ;
                                   INT ;
                                   EQ ;
                                   IF { DROP ; NONE nat } { SOME } ;
                                   SWAP ;
                                   CAR ;
                                   DIP { DIP { DUP ; CAR ; DIP { CDR } } } ;
                                   UPDATE ;
                                   PAIR } ;
                             DUP ;
                             DIP { CDR ;
                                   NEG ;
                                   DIP { DUP ; CDR } ;
                                   ADD ;
                                   ISNAT ;
                                   IF_NONE { PUSH string "Internal: Negative total supply" ; FAILWITH } {} ;
                                   DIP { DUP ; DIP { CAR } ; CDR } ;
                                   DIP { DROP } ;
                                   SWAP ;
                                   PAIR } ;
                             DROP ;
                             NIL operation ;
                             PAIR } } } } }
        Initial storage: (Pair {} 0)
        No delegate for this contract
        This origination was successfully applied
        Originated contracts:
          KT1Me2DzRgrGmPx2ZnhsXBuRgDdzjXUUpz83
        Storage size: 1797 bytes
        Updated big_maps:
          New map(1523) of type (big_map address nat)
        Paid storage size diff: 1797 bytes
        Consumed gas: 54551
        Balance updates:
          tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ... -ꜩ1.797
          tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ... -ꜩ0.257

New contract KT1Me2DzRgrGmPx2ZnhsXBuRgDdzjXUUpz83 originated.
Contract memorized as SpecializedManagedLedger.
```


```bash
MLS_ADDRESS="KT1SrL6srXSzZmv1BS3LmLyMXVaVU5srY2Yk"
```

Mint 10 tokens to alice:

```haskell
*Main MLS Data.Coerce Util.Named> printLorentzValue True $ MLS.Mint (#to .! "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr", #value .! 10)
"Right (Right (Left (Pair \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\" 10)))"
```

```bash
❯❯❯ alpha-client --wait none transfer 0 from $ALICE_ADDRESS to $MLS_ADDRESS \
  --arg "Right (Right (Left (Pair \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\" 10)))" --burn-cap 0.067

Waiting for the node to be bootstrapped before injection...
Current head: BLSkBn9shj3W (timestamp: 2020-01-13T22:24:26-00:00, validation: 2020-01-13T22:24:34-00:00)
Node is bootstrapped, ready for injecting operations.
Estimated gas: 46758 units (will add 100 for safety)
Estimated storage: 67 bytes added (will add 20 for safety)
:Operation successfully injected in the node.
Operation hash is 'opZCnSAH8dWrZR4QrYBuJXWrrvN8RzwTG1e6M86g9vmapQgAPsv'
NOT waiting for the operation to be included.
Use command
  tezos-client wait for opZCnSAH8dWrZR4QrYBuJXWrrvN8RzwTG1e6M86g9vmapQgAPsv to be included --confirmations 30 --branch BLSkBn9shj3WaqW3xiYvt4UBLrbaYV8U8TDimKGNKGvqWRVp3dU
and/or an external block explorer to make sure that it has been included.
This sequence of operations was run:
  Manager signed operations:
    From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
    Fee to the baker: ꜩ0.004993
    Expected counter: 84680
    Gas limit: 46858
    Storage limit: 87 bytes
    Balance updates:
      tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ............. -ꜩ0.004993
      fees(tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU,102) ... +ꜩ0.004993
    Transaction:
      Amount: ꜩ0
      From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
      To: KT1RGRvSgi5BbJ4jHmr3LFaoNKajqhnsrDKx
      Parameter: (Right (Right (Left (Pair "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr" 10))))
      This transaction was successfully applied
      Updated storage: (Pair 1524 10)
      Updated big_maps:
        Set map(1524)[0x00003b5d4596c032347b72fb51f688c45200d0cb50db] to 10
      Storage size: 1829 bytes
      Paid storage size diff: 67 bytes
      Consumed gas: 46758
      Balance updates:
        tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ... -ꜩ0.067
```



Transfer 5 tokens from alice to bob:

```haskell
*Main MLS Data.Coerce Util.Named> printLorentzValue True $ MLS.Transfer (#from .! "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr", #to .! "tz1bDCu64RmcpWahdn9bWrDMi6cu7mXZynHm", #value .! 5)
"Left (Left (Pair \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\" (Pair \"tz1bDCu64RmcpWahdn9bWrDMi6cu7mXZynHm\" 5)))"
```

```bash
~/C/m/lorentz-contract-fa14 ❯❯❯ alpha-client --wait none transfer 0 from $ALICE_ADDRESS to $MLS_ADDRESS \                                                                                                                                    $ 
  --arg "Left (Left (Pair \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\" (Pair \"tz1bDCu64RmcpWahdn9bWrDMi6cu7mXZynHm\" 3)))" --dry-run --burn-cap 0.067
Warning:
  
                 This is NOT the Tezos Mainnet.
  
     The node you are connecting to claims to be running on the
               Tezos Alphanet DEVELOPMENT NETWORK.
          Do NOT use your fundraiser keys on this network.
          Alphanet is a testing network, with free tokens.

Waiting for the node to be bootstrapped before injection...
Current head: BLZtqYnYfjav (timestamp: 2020-01-13T21:36:00-00:00, validation: 2020-01-13T21:36:34-00:00)
Node is bootstrapped, ready for injecting operations.
Estimated gas: 57615 units (will add 100 for safety)
Estimated storage: 67 bytes added (will add 20 for safety)
Operation: 0x70a67df799773ae0da4153a10dbac5128553191efcf98e6382ee2a69320fb22f6c003b5d4596c032347b72fb51f688c45200d0cb50dbe82ffd9405f3c203570001e77ad3d18c7ffaadbfa2ea618a64c3b12ee5d6b900ff000000005c0505050507070100000024747a315233764a35545638593570566a38646963425232335a76384a41727573446b597207070100000024747a31624443753634526d6370576168646e39625772444d69366375376d585a796e486d000378aadf366b3c44ff13f36909a75b2034115f9f21d91e54a101d0fe153339dcbbf7fa5ee73bc3ab5dd8663deb2ccc55d558b46584bd9e45e602f22d168a1c7a06
Operation hash is 'ooN1ASRJD9hqywmkKshPbb5q8491gTaAy5rgW3rZbAB82x3Puqn'
Simulation result:
  Manager signed operations:
    From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
    Fee to the baker: ꜩ0.00612
    Expected counter: 84605
    Gas limit: 57715
    Storage limit: 87 bytes
    Balance updates:
      tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ............. -ꜩ0.00612
      fees(tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU,102) ... +ꜩ0.00612
    Transaction:
      Amount: ꜩ0
      From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
      To: KT1VgioH1A9AfwKAJu8cHTSepV3P5fHWpR74
      Parameter: (Left (Left (Pair "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr"
                                   (Pair "tz1bDCu64RmcpWahdn9bWrDMi6cu7mXZynHm" 3))))
      This transaction was successfully applied
      Updated storage: (Pair 1522 10)
      Updated big_maps:
        Set map(1522)[0x00003b5d4596c032347b72fb51f688c45200d0cb50db] to 7
        Set map(1522)[0x0000aad02222472cdf9892a3011c01caf6407f027081] to 3
      Storage size: 2323 bytes
      Paid storage size diff: 67 bytes
      Consumed gas: 57615
      Balance updates:
        tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ... -ꜩ0.067
```

