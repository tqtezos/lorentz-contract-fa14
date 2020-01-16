
See the FA1.2 [Quick Start Tutorial](https://assets.tqtezos.com/quickstart) for more detail.

```haskell
*Main Michelson.Typed.T MSHI Lorentz.Contracts.ManagedLedger.Specialized> printLorentzContract True $ MSHI.hookedSpecializedManagedLedgerContract "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr"
"parameter (or (or (or (pair %transfer address (pair (address :from) (pair (address :to) (nat :value)))) (option %setHooks (lambda unit (contract (pair address (pair (bool :isTo) (pair (address :user) (nat :value)))))))) (or (pair %getHooks address (contract (option (lambda unit (contract (pair address (pair (bool :isTo) (pair (address :user) (nat :value))))))))) (pair %getBalance (pair address (address :owner)) (contract nat)))) (or (or (pair %getTotalSupply (address :whichToken) (contract nat)) (pair %getAdministrator unit (contract address))) (or (pair %mint address (pair (address :to) (nat :value))) (pair %burn address (pair (address :from) (nat :value))))));storage (pair (big_map address (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat)))))))) nat);code { CAST (pair (or (or (or (pair address (pair address (pair address nat))) (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) (or (pair address (contract (option (lambda unit (contract (pair address (pair bool (pair address nat)))))))) (pair (pair address address) (contract nat)))) (or (or (pair address (contract nat)) (pair unit (contract address))) (or (pair address (pair address nat)) (pair address (pair address nat))))) (pair (big_map address (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat)))))))) nat));DUP;CAR;DIP { CDR };IF_LEFT { IF_LEFT { IF_LEFT { DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };DIP { DUP;CAR;DIP { CDR } };DUP;DIP { CDR;CAR };SWAP;DIP { SWAP };DIP { DUP };DUP;DIP { GET };SWAP;IF_NONE { DIP { DIP { PUSH nat 0 };SWAP;DIP { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None };PAIR;SOME };UPDATE;NONE operation }        { DUP;DIP { PAIR;SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { SWAP;DUP;CDR;PUSH bool True;PAIR;SELF;ADDRESS;PAIR;DIP { DUP;DIP { CDR;CDR;ADD };SWAP } };IF_NONE { DROP;NONE operation }        { UNIT;EXEC;SWAP;DIP { PUSH mutez 0 };TRANSFER_TOKENS;SOME };PAIR };PAIR };SWAP;DUP;CAR;DIP { CDR };SWAP;DUP;CAR;DIP { CDR };DIP { SWAP } };SWAP;DIP { CDR;SWAP;DIP { SWAP;PAIR;SOME };UPDATE } };DIP { DIP { DUP };SWAP;CAR;DIP { DUP };DUP;DIP { GET };SWAP;IF_NONE { PUSH string \"sender unknown\";PAIR;FAILWITH }        { DUP;DIP { PAIR;SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { SWAP;DUP;DUP;CAR;DIP { CDR };DIP { CDR };PAIR;PUSH bool False;PAIR;SELF;ADDRESS;PAIR;DIP { CDR;CDR;SWAP;SUB;ISNAT;IF_NONE { PUSH string \"insufficient balance\";PAIR;FAILWITH }        {  } } };IF_NONE { DROP;NONE operation }        { UNIT;EXEC;SWAP;DIP { PUSH mutez 0 };TRANSFER_TOKENS;SOME };PAIR };PAIR };SWAP;DUP;CAR;DIP { CDR };SWAP;DUP;CAR;DIP { CDR };DIP { SWAP } };SWAP;DIP { CDR;SWAP;DIP { SWAP;PAIR;SOME };UPDATE } } };IF_NONE { IF_NONE { NIL operation }        { DIP { NIL operation };CONS } }        { DIP { NIL operation };CONS;SWAP;IF_NONE {  }        { CONS } };DIP { PAIR };PAIR }        { DIP { DUP;CAR;DIP { CDR };DUP;SENDER;GET;IF_NONE { PUSH nat 0 }        { CAR } };SWAP;PAIR;SOME;SENDER;UPDATE;PAIR;NIL operation;PAIR } }        { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };DIP { CAR };GET;IF_NONE { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None }        { CDR };DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };DIP { CAR };GET;IF_NONE { PUSH nat 0 }        { CAR };DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR } } }        { IF_LEFT { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };CDR;DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DROP;PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR } }        { IF_LEFT { DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { DUP;CDR;INT;EQ;IF { NONE (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) }   { DUP;CDR;DIP { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None };PAIR;SOME } }        { DIP { DUP };SWAP;CDR;DIP { DUP;CAR;DIP { CDR } };ADD;PAIR;SOME };SWAP;DUP;DIP { CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;INT;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR }        { DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { CDR;PUSH nat 0;SWAP;PAIR;PUSH string \"NotEnoughBalance\";PAIR;FAILWITH }        {  };DUP;CAR;DIP { CDR };DIP { SWAP };DUP;DIP { SWAP;DUP;CDR };SUB;ISNAT;DIP { SWAP };IF_NONE { PUSH string \"insufficient balance\";PAIR;FAILWITH }        { DIP { DROP } };DIP { DUP };SWAP;DIP { DIP { SWAP };PAIR;DUP;CAR;INT;EQ;IF { DROP;NONE (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) }   { SOME };SWAP;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;NEG;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR } } } };"
```

```bash
❯❯❯ alpha-client --wait none originate contract MSHI \
  transferring 0 from $ALICE_ADDRESS running \
  "parameter (or (or (or (pair %transfer address (pair (address :from) (pair (address :to) (nat :value)))) (option %setHooks (lambda unit (contract (pair address (pair (bool :isTo) (pair (address :user) (nat :value)))))))) (or (pair %getHooks address (contract (option (lambda unit (contract (pair address (pair (bool :isTo) (pair (address :user) (nat :value))))))))) (pair %getBalance (pair address (address :owner)) (contract nat)))) (or (or (pair %getTotalSupply (address :whichToken) (contract nat)) (pair %getAdministrator unit (contract address))) (or (pair %mint address (pair (address :to) (nat :value))) (pair %burn address (pair (address :from) (nat :value))))));storage (pair (big_map address (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat)))))))) nat);code { CAST (pair (or (or (or (pair address (pair address (pair address nat))) (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) (or (pair address (contract (option (lambda unit (contract (pair address (pair bool (pair address nat)))))))) (pair (pair address address) (contract nat)))) (or (or (pair address (contract nat)) (pair unit (contract address))) (or (pair address (pair address nat)) (pair address (pair address nat))))) (pair (big_map address (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat)))))))) nat));DUP;CAR;DIP { CDR };IF_LEFT { IF_LEFT { IF_LEFT { DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };DIP { DUP;CAR;DIP { CDR } };DUP;DIP { CDR;CAR };SWAP;DIP { SWAP };DIP { DUP };DUP;DIP { GET };SWAP;IF_NONE { DIP { DIP { PUSH nat 0 };SWAP;DIP { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None };PAIR;SOME };UPDATE;NONE operation }        { DUP;DIP { PAIR;SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { SWAP;DUP;CDR;PUSH bool True;PAIR;SELF;ADDRESS;PAIR;DIP { DUP;DIP { CDR;CDR;ADD };SWAP } };IF_NONE { DROP;NONE operation }        { UNIT;EXEC;SWAP;DIP { PUSH mutez 0 };TRANSFER_TOKENS;SOME };PAIR };PAIR };SWAP;DUP;CAR;DIP { CDR };SWAP;DUP;CAR;DIP { CDR };DIP { SWAP } };SWAP;DIP { CDR;SWAP;DIP { SWAP;PAIR;SOME };UPDATE } };DIP { DIP { DUP };SWAP;CAR;DIP { DUP };DUP;DIP { GET };SWAP;IF_NONE { PUSH string \"sender unknown\";PAIR;FAILWITH }        { DUP;DIP { PAIR;SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { DUP;CAR;DIP { CDR };SWAP;DIP { SWAP;DUP;DUP;CAR;DIP { CDR };DIP { CDR };PAIR;PUSH bool False;PAIR;SELF;ADDRESS;PAIR;DIP { CDR;CDR;SWAP;SUB;ISNAT;IF_NONE { PUSH string \"insufficient balance\";PAIR;FAILWITH }        {  } } };IF_NONE { DROP;NONE operation }        { UNIT;EXEC;SWAP;DIP { PUSH mutez 0 };TRANSFER_TOKENS;SOME };PAIR };PAIR };SWAP;DUP;CAR;DIP { CDR };SWAP;DUP;CAR;DIP { CDR };DIP { SWAP } };SWAP;DIP { CDR;SWAP;DIP { SWAP;PAIR;SOME };UPDATE } } };IF_NONE { IF_NONE { NIL operation }        { DIP { NIL operation };CONS } }        { DIP { NIL operation };CONS;SWAP;IF_NONE {  }        { CONS } };DIP { PAIR };PAIR }        { DIP { DUP;CAR;DIP { CDR };DUP;SENDER;GET;IF_NONE { PUSH nat 0 }        { CAR } };SWAP;PAIR;SOME;SENDER;UPDATE;PAIR;NIL operation;PAIR } }        { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };DIP { CAR };GET;IF_NONE { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None }        { CDR };DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };DIP { CAR };GET;IF_NONE { PUSH nat 0 }        { CAR };DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR } } }        { IF_LEFT { IF_LEFT { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };CDR;DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR }        { DUP;CAR;DIP { CDR };DIP { DIP { DUP };SWAP };PAIR;DROP;PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";DIP { AMOUNT };TRANSFER_TOKENS;NIL operation;SWAP;CONS;PAIR } }        { IF_LEFT { DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { DUP;CDR;INT;EQ;IF { NONE (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) }   { DUP;CDR;DIP { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None };PAIR;SOME } }        { DIP { DUP };SWAP;CDR;DIP { DUP;CAR;DIP { CDR } };ADD;PAIR;SOME };SWAP;DUP;DIP { CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;INT;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR }        { DUP;CAR;DIP { CDR };SELF;ADDRESS;COMPARE;EQ;IF {  }   { PUSH string \"whichToken not self\";FAILWITH };PUSH address \"tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr\";SENDER;COMPARE;EQ;IF {  }   { UNIT;PUSH string \"SenderIsNotAdmin\";PAIR;FAILWITH };DIP { DUP };SWAP;DIP { DUP };SWAP;CAR;DIP { CAR };GET;IF_NONE { CDR;PUSH nat 0;SWAP;PAIR;PUSH string \"NotEnoughBalance\";PAIR;FAILWITH }        {  };DUP;CAR;DIP { CDR };DIP { SWAP };DUP;DIP { SWAP;DUP;CDR };SUB;ISNAT;DIP { SWAP };IF_NONE { PUSH string \"insufficient balance\";PAIR;FAILWITH }        { DIP { DROP } };DIP { DUP };SWAP;DIP { DIP { SWAP };PAIR;DUP;CAR;INT;EQ;IF { DROP;NONE (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) }   { SOME };SWAP;CAR;DIP { DIP { DUP;CAR;DIP { CDR } } };UPDATE;PAIR };DUP;DIP { CDR;NEG;DIP { DUP;CDR };ADD;ISNAT;IF_NONE { PUSH string \"Internal: Negative total supply\";FAILWITH }        {  };DIP { DUP;DIP { CAR };CDR };DIP { DROP };SWAP;PAIR };DROP;NIL operation;PAIR } } } };" \
  --init "Pair { } 0" --burn-cap 3.515

Waiting for the node to be bootstrapped before injection...
Current head: BMDZkwTmAPqM (timestamp: 2020-01-16T21:19:36-00:00, validation: 2020-01-16T21:19:49-00:00)
Node is bootstrapped, ready for injecting operations.
Estimated gas: 99586 units (will add 100 for safety)
Estimated storage: 3515 bytes added (will add 20 for safety)
Operation successfully injected in the node.
Operation hash is 'ooFHKQw9eeS4JziPB9xfFWnNfXE6Hz2ZEBE59juHQqhhgjzzc2Y'
NOT waiting for the operation to be included.
Use command
  tezos-client wait for ooFHKQw9eeS4JziPB9xfFWnNfXE6Hz2ZEBE59juHQqhhgjzzc2Y to be included --confirmations 30 --branch BMDZkwTmAPqMq3EZQkuPu7Dcf5sGTrC3enUDMcJYsg7HRBGBmK6
and/or an external block explorer to make sure that it has been included.
This sequence of operations was run:
  Manager signed operations:
    From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
    Fee to the baker: ꜩ0.013426
    Expected counter: 90793
    Gas limit: 99686
    Storage limit: 3535 bytes
    Balance updates:
      tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ............. -ꜩ0.013426
      fees(tz1Ke2h7sDdakHJQh8WX4Z372du1KChsksyU,106) ... +ꜩ0.013426
    Origination:
      From: tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr
      Credit: ꜩ0
      Script:
        { parameter
            (or (or (or (pair %transfer address (pair (address :from) (pair (address :to) (nat :value))))
                        (option %setHooks
                           (lambda
                              unit
                              (contract (pair address (pair (bool :isTo) (pair (address :user) (nat :value))))))))
                    (or (pair %getHooks
                           address
                           (contract
                              (option
                                 (lambda
                                    unit
                                    (contract (pair address (pair (bool :isTo) (pair (address :user) (nat :value)))))))))
                        (pair %getBalance (pair address (address :owner)) (contract nat))))
                (or (or (pair %getTotalSupply (address :whichToken) (contract nat))
                        (pair %getAdministrator unit (contract address)))
                    (or (pair %mint address (pair (address :to) (nat :value)))
                        (pair %burn address (pair (address :from) (nat :value)))))) ;
          storage
            (pair (big_map
                     address
                     (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))))
                  nat) ;
          code { CAST (pair (or (or (or (pair address (pair address (pair address nat)))
                                        (option (lambda unit (contract (pair address (pair bool (pair address nat)))))))
                                    (or (pair address
                                              (contract (option (lambda unit (contract (pair address (pair bool (pair address nat))))))))
                                        (pair (pair address address) (contract nat))))
                                (or (or (pair address (contract nat)) (pair unit (contract address)))
                                    (or (pair address (pair address nat)) (pair address (pair address nat)))))
                            (pair (big_map
                                     address
                                     (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))))
                                  nat)) ;
                 DUP ;
                 CAR ;
                 DIP { CDR } ;
                 IF_LEFT
                   { IF_LEFT
                       { IF_LEFT
                           { DUP ;
                             CAR ;
                             DIP { CDR } ;
                             SELF ;
                             ADDRESS ;
                             COMPARE ;
                             EQ ;
                             IF {} { PUSH string "whichToken not self" ; FAILWITH } ;
                             DIP { DUP ; CAR ; DIP { CDR } } ;
                             DUP ;
                             DIP { CDR ; CAR } ;
                             SWAP ;
                             DIP { SWAP } ;
                             DIP { DUP } ;
                             DUP ;
                             DIP { GET } ;
                             SWAP ;
                             IF_NONE
                               { DIP { DIP { PUSH nat 0 } ;
                                       SWAP ;
                                       DIP { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None } ;
                                       PAIR ;
                                       SOME } ;
                                 UPDATE ;
                                 NONE operation }
                               { DUP ;
                                 DIP { PAIR ;
                                       SWAP ;
                                       DIP { DUP ;
                                             CAR ;
                                             DIP { CDR } ;
                                             SWAP ;
                                             DIP { DUP ;
                                                   CAR ;
                                                   DIP { CDR } ;
                                                   SWAP ;
                                                   DIP { SWAP ;
                                                         DUP ;
                                                         CDR ;
                                                         PUSH bool True ;
                                                         PAIR ;
                                                         SELF ;
                                                         ADDRESS ;
                                                         PAIR ;
                                                         DIP { DUP ; DIP { CDR ; CDR ; ADD } ; SWAP } } ;
                                                   IF_NONE
                                                     { DROP ; NONE operation }
                                                     { UNIT ; EXEC ; SWAP ; DIP { PUSH mutez 0 } ; TRANSFER_TOKENS ; SOME } ;
                                                   PAIR } ;
                                             PAIR } ;
                                       SWAP ;
                                       DUP ;
                                       CAR ;
                                       DIP { CDR } ;
                                       SWAP ;
                                       DUP ;
                                       CAR ;
                                       DIP { CDR } ;
                                       DIP { SWAP } } ;
                                 SWAP ;
                                 DIP { CDR ; SWAP ; DIP { SWAP ; PAIR ; SOME } ; UPDATE } } ;
                             DIP { DIP { DUP } ;
                                   SWAP ;
                                   CAR ;
                                   DIP { DUP } ;
                                   DUP ;
                                   DIP { GET } ;
                                   SWAP ;
                                   IF_NONE
                                     { PUSH string "sender unknown" ; PAIR ; FAILWITH }
                                     { DUP ;
                                       DIP { PAIR ;
                                             SWAP ;
                                             DIP { DUP ;
                                                   CAR ;
                                                   DIP { CDR } ;
                                                   SWAP ;
                                                   DIP { DUP ;
                                                         CAR ;
                                                         DIP { CDR } ;
                                                         SWAP ;
                                                         DIP { SWAP ;
                                                               DUP ;
                                                               DUP ;
                                                               CAR ;
                                                               DIP { CDR } ;
                                                               DIP { CDR } ;
                                                               PAIR ;
                                                               PUSH bool False ;
                                                               PAIR ;
                                                               SELF ;
                                                               ADDRESS ;
                                                               PAIR ;
                                                               DIP { CDR ;
                                                                     CDR ;
                                                                     SWAP ;
                                                                     SUB ;
                                                                     ISNAT ;
                                                                     IF_NONE { PUSH string "insufficient balance" ; PAIR ; FAILWITH } {} } } ;
                                                         IF_NONE
                                                           { DROP ; NONE operation }
                                                           { UNIT ; EXEC ; SWAP ; DIP { PUSH mutez 0 } ; TRANSFER_TOKENS ; SOME } ;
                                                         PAIR } ;
                                                   PAIR } ;
                                             SWAP ;
                                             DUP ;
                                             CAR ;
                                             DIP { CDR } ;
                                             SWAP ;
                                             DUP ;
                                             CAR ;
                                             DIP { CDR } ;
                                             DIP { SWAP } } ;
                                       SWAP ;
                                       DIP { CDR ; SWAP ; DIP { SWAP ; PAIR ; SOME } ; UPDATE } } } ;
                             IF_NONE
                               { IF_NONE { NIL operation } { DIP { NIL operation } ; CONS } }
                               { DIP { NIL operation } ; CONS ; SWAP ; IF_NONE {} { CONS } } ;
                             DIP { PAIR } ;
                             PAIR }
                           { DIP { DUP ;
                                   CAR ;
                                   DIP { CDR } ;
                                   DUP ;
                                   SENDER ;
                                   GET ;
                                   IF_NONE { PUSH nat 0 } { CAR } } ;
                             SWAP ;
                             PAIR ;
                             SOME ;
                             SENDER ;
                             UPDATE ;
                             PAIR ;
                             NIL operation ;
                             PAIR } }
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
                             IF_NONE
                               { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None }
                               { CDR } ;
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
                             DUP ;
                             CAR ;
                             DIP { CDR } ;
                             DUP ;
                             CAR ;
                             DIP { CDR } ;
                             SELF ;
                             ADDRESS ;
                             COMPARE ;
                             EQ ;
                             IF {} { PUSH string "whichToken not self" ; FAILWITH } ;
                             DIP { CAR } ;
                             GET ;
                             IF_NONE { PUSH nat 0 } { CAR } ;
                             DIP { AMOUNT } ;
                             TRANSFER_TOKENS ;
                             NIL operation ;
                             SWAP ;
                             CONS ;
                             PAIR } } }
                   { IF_LEFT
                       { IF_LEFT
                           { DUP ;
                             CAR ;
                             DIP { CDR } ;
                             DIP { DIP { DUP } ; SWAP } ;
                             PAIR ;
                             DUP ;
                             CAR ;
                             DIP { CDR } ;
                             SELF ;
                             ADDRESS ;
                             COMPARE ;
                             EQ ;
                             IF {} { PUSH string "whichToken not self" ; FAILWITH } ;
                             CDR ;
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
                             DROP ;
                             PUSH address "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr" ;
                             DIP { AMOUNT } ;
                             TRANSFER_TOKENS ;
                             NIL operation ;
                             SWAP ;
                             CONS ;
                             PAIR } }
                       { IF_LEFT
                           { DUP ;
                             CAR ;
                             DIP { CDR } ;
                             SELF ;
                             ADDRESS ;
                             COMPARE ;
                             EQ ;
                             IF {} { PUSH string "whichToken not self" ; FAILWITH } ;
                             PUSH address "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr" ;
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
                               { DUP ;
                                 CDR ;
                                 INT ;
                                 EQ ;
                                 IF { NONE (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) }
                                    { DUP ;
                                      CDR ;
                                      DIP { PUSH (option (lambda unit (contract (pair address (pair bool (pair address nat)))))) None } ;
                                      PAIR ;
                                      SOME } }
                               { DIP { DUP } ;
                                 SWAP ;
                                 CDR ;
                                 DIP { DUP ; CAR ; DIP { CDR } } ;
                                 ADD ;
                                 PAIR ;
                                 SOME } ;
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
                           { DUP ;
                             CAR ;
                             DIP { CDR } ;
                             SELF ;
                             ADDRESS ;
                             COMPARE ;
                             EQ ;
                             IF {} { PUSH string "whichToken not self" ; FAILWITH } ;
                             PUSH address "tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr" ;
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
                             CAR ;
                             DIP { CDR } ;
                             DIP { SWAP } ;
                             DUP ;
                             DIP { SWAP ; DUP ; CDR } ;
                             SUB ;
                             ISNAT ;
                             DIP { SWAP } ;
                             IF_NONE
                               { PUSH string "insufficient balance" ; PAIR ; FAILWITH }
                               { DIP { DROP } } ;
                             DIP { DUP } ;
                             SWAP ;
                             DIP { DIP { SWAP } ;
                                   PAIR ;
                                   DUP ;
                                   CAR ;
                                   INT ;
                                   EQ ;
                                   IF { DROP ;
                                        NONE (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))) }
                                      { SOME } ;
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
          KT1QMZeVkUdnnFguJo5hgMjZRZKK63YBfsGr
        Storage size: 3258 bytes
        Updated big_maps:
          New map(1559) of type (big_map address (pair nat (option (lambda unit (contract (pair address (pair bool (pair address nat))))))))
        Paid storage size diff: 3258 bytes
        Consumed gas: 99586
        Balance updates:
          tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ... -ꜩ3.258
          tz1R3vJ5TV8Y5pVj8dicBR23Zv8JArusDkYr ... -ꜩ0.257

New contract KT1QMZeVkUdnnFguJo5hgMjZRZKK63YBfsGr originated.
Contract memorized as MSHI.
```

[KT1QMZeVkUdnnFguJo5hgMjZRZKK63YBfsGr](https://better-call.dev/babylon/KT1QMZeVkUdnnFguJo5hgMjZRZKK63YBfsGr/operations)




