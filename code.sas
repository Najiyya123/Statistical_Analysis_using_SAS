/* ===============================
   Project: Credit Risk Analysis
   Tool: SAS OnDemand for Academics
   =============================== */

/* Step 1: Import Data */
proc import datafile="/home/yourusername/loan_data.csv"
    out=loan_data
    dbms=csv
    replace;
    getnames=yes;
run;

/* Step 2: Explore the structure */
proc contents data=loan_data;
run;

/* Step 3: Clean and format data */
data clean_data;
    set loan_data;
    if missing(Defaulted) or missing(Income) or missing(CreditScore) or missing(LoanAmount) then delete;
    Defaulted_binary = (Defaulted = "Yes");
run;

/* Step 4: Summary statistics */
proc means data=clean_data n mean std min max;
    var Income CreditScore LoanAmount;
    title "Descriptive Statistics for Loan Applicants";
run;

/* Step 5: Correlation between numeric variables */
proc corr data=clean_data;
    var Income CreditScore LoanAmount;
run;

/* Step 6: Logistic regression to predict default */
proc logistic data=clean_data;
    model Defaulted_binary(event='1') = Income CreditScore LoanAmount;
    title "Logistic Regression Model: Predicting Loan Default";
run;

/* Step 7: Frequency table for target variable */
proc freq data=clean_data;
    tables Defaulted;
run;

/* Step 8: Basic visualization */
proc sgplot data=clean_data;
    scatter x=CreditScore y=LoanAmount / group=Defaulted;
    title "Loan Amount vs Credit Score by Default Status";
run;
