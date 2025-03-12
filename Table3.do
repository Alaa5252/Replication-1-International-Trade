* A. Preparing data.
* 1.Settting the work directory: 
cd "C:\Trade Replication\Output Files"

* 2.Loading the disaggregated data set of bilateral trade (cleaned and filtered):
import excel "RowDataSTAN.xlsx", clear firstrow

* 3.Checking data and reviewing variables:
list in 1/10
describe

* B. Calculating the share of industry produced domestically in country i:
* 4.Summing exports for each country and industry:
collapse (sum) OBS_VALUE, by(COU IND FLW)

* 5. Calculating total value of output including both imports and exports:
collapse (sum) OBS_VALUE, by(COU IND)

* 6. Calculating πii: the export value divided by the total output (exports + imports) in the industry:
bysort COU IND: gen total_output = sum(OBS_VALUE)
gen pi_ii_k = OBS_VALUE / total_output

* C. Calculating the corrected exports:
gen x_ijk = log(pi_ii_k)

* D. Calculating the Import Penetration Ratio (IPR):
gen IPR = 1 - pi_ii_k

* E. Exporting the results:
export delimited "C:\Trade Replication\Output Files", replace

* F. The exported excel file from the last step is the aggregated bilateral trade data in each country in the sample and for each industry. Using Excel, I added all the variables from PLD and R&D variable to this exported results file (now I have a new merged Excel file named: DataForTable3New.xlsx). Please note that I gave each country code (there are 21 of them) and each industry code (there are 6 of them), which include letters, I gave them special numerical codes.

* 7. Loading the merged data set:
import excel using "C:\Trade Replication\Output Files\DataForTable3New.xlsx", clear firstrow

* 8. Preparing data:
rename COU countrycode
rename IND industry_code
rename OBS_VALUE export_value
rename total_output total_output_value
rename pi_ii_k domestic_expenditure_ratio
rename x_ijk corrected_exports
rename IPR import_penetration_ratio
rename VA value_added
rename EMP employment
rename PPP_y ppp_y
rename PPP_z ppp_z
rename PPP_va ppp_va
rename RD R_and_D


*9. Calculating corrected exports:
gen corrected_exports1 = log(export_value) - log(domestic_expenditure_ratio)

* 10. Transforming variables:
gen log_corrected_exports = log(corrected_exports1)
gen log_productivity = log(ppp_va)  // This is the log of productivity based on producer prices
gen log_export_value = log(export_value)
gen log_total_output = log(total_output_value)
gen log_RD = log(R_and_D)


* G. Regression Models:

* 11. OLS Estimation (Columns 1 and 2 of Table 3):

* 11.1. Column (1) Estimation (OLS): In Column (1), I estimate the basic model with fixed effects for exporter and industry, adjusting for observed productivity:
reg log_corrected_exports log_productivity i.countrycode i.industry_code

* 11.2. Column (2) Estimation (OLS without Productivity Adjustment): For Column (2), I run the regression without adjusting for the difference between observed and fundamental productivity:
reg log_export_value log_productivity i.countrycode i.industry_code

* 12. Instrumental Variables Estimation (Columns 3 and 4 of Table 3):

* 12.1. Column (3) Estimation (IV with R&D as Instrument): For Column (3), I estimate using instrumental variables (IV). I instrument log_productivity with log (R_and_D):
ivregress 2sls log_corrected_exports (log_productivity = log_RD) i.countrycode i.industry_code

* 12.2. Column (4) Estimation (IV without Productivity Adjustment): For Column (4), I estimate the model without the adjustment for the distinction between observed and fundamental productivity:
ivregress 2sls log_export_value (log_productivity = log_RD) i.countrycode i.industry_code
