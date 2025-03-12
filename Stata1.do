import excel using "C:\Trade Replication\Output Files\File1.xlsx", clear firstrow

foreach var of varlist agr bus con dwe fin man min oth pu pub tra trd {
    gen `var'2 = 1/`var'
}


foreach var of varlist agr2 bus2 con2 dwe2 fin2 man2 min2 oth2 pu2 pub2 tra2 trd2 {
    gen `var'2 = `var'/ agr2
}

rename (agr22 bus22 con22 dwe22 fin22 man22 min22 oth22 pu22 pub22 tra22 trd22) (Agriculture Business Construction Realestate Finance Manufacturing Mining Otherservices Utilities Government Transport Trade)

foreach var in Agriculture Business Construction Realestate Finance Manufacturing Mining Otherservices Utilities Government Transport Trade {
    replace `var' = round(`var', 0.01)
    format `var' %9.2f
}

export delimited Country Agriculture Business Construction Realestate Finance Manufacturing Mining Otherservices Utilities Government Transport Trade using "C:\Trade Replication\Output Files\File1Results.csv", replace