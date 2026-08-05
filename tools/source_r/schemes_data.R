########################################################################
# schemes_data.R — basic-info database of ALL schemes supplied across
# the uploaded documents (WB state schemes, central schemes applicable
# to WB, official wb.gov.in scheme list, and MSME/business incentives).
#
# This is the "browse" tier: name, benefit, status, how to apply, and
# contact info only. It is NOT the troubleshooting tier — the small set
# of high-volume schemes with full diagnosis logic lives in app.R's
# `content` list (Annapurna Bhandar, Swasthya Sathi, Ration Card/SIR).
#
# Source this file from app.R with: source("schemes_data.R")
########################################################################

col_names <- c("category","name_en","name_bn","status","benefit","apply","contact")

# ---- Women, Family & Social Security ----
women_family <- data.frame(stringsAsFactors = FALSE,
  category = "Women & Family",
  name_en = c(
    "Annapurna Bhandar (formerly Lakshmir Bhandar)",
    "Kanyashree Prakalpa",
    "Rupashree Prakalpa",
    "Widow Pension (WB)",
    "Old Age Pension (WB)",
    "Nischay SHG Loan",
    "BOCW Maternity & Child Welfare",
    "Beti Bachao Beti Padhao",
    "Sukanya Samriddhi Yojana",
    "Bina Mulya Samajik Suraksha Yojana (BM-SSY)"
  ),
  name_bn = c("অন্নপূর্ণা ভাণ্ডার", "কন্যাশ্রী", "রূপশ্রী", "বিধবা ভাতা", "বার্ধক্য ভাতা",
              "নিশ্চয় SHG ঋণ", "", "", "সুকন্যা সমৃদ্ধি", "বিনামূল্যে সামাজিক সুরক্ষা"),
  status = c("Transitioning from Lakshmir Bhandar, live from 1 June 2026",
             "Live", "Live", "Live", "Live", "Live", "Live",
             "Live (awareness/convergence scheme, no direct cash)", "Live", "Live"),
  benefit = c("~\u20b93,000/month DBT for eligible women 25-60",
              "K1: \u20b91,000/year (13-18) + K2: \u20b925,000 one-time (18+, unmarried)",
              "\u20b925,000 one-time grant at marriage",
              "Monthly pension for widows facing economic hardship",
              "Monthly pension for eligible seniors",
              "Up to \u20b92 lakh SHG group loan at 7%, up to \u20b910 lakh for mature SHGs",
              "\u20b920,000 maternity + \u20b95,000 child care benefit for registered BOCW women workers",
              "Awareness, education-linkage, and convergence support for girl children; no direct cash",
              "8.2% interest savings account for a girl child, tax-exempt under 80C",
              "Free life/accident/disability insurance for unorganised sector workers, 18-60 yrs"
  ),
  apply = c("Social registry portal or BDO/SDO office; existing Lakshmir Bhandar recipients should confirm migration status, not assume it's automatic",
            "School/college nodal officer, or via Kanyashree portal",
            "Duare Sarkar camp or BDO office at time of marriage",
            "BDO/Municipality office with income and marital status proof",
            "BDO/Municipality office",
            "Through registered SHG, via block-level SHG coordinator",
            "BOCW Welfare Board registration + application",
            "No individual application; contact Anganwadi Centre, school, or District Women & Child Development Office for linkage",
            "Post office or authorised bank branch",
            "Online via BM-SSY portal, or offline via Regional Labour Office / Block Labour Welfare Facilitation Centre"
  ),
  contact = c("socialregistry.wb.gov.in \u00b7 helpline 1800-345-0017",
              "wbkanyashree.gov.in",
              "wb.gov.in \u00b7 Duare Sarkar camp",
              "Local BDO/Municipality office",
              "Local BDO/Municipality office",
              "Block SHG coordinator / Panchayat office",
              "bocwwbwb.gov.in",
              "Childline 1098 \u00b7 wcd.gov.in",
              "Any post office or bank",
              "bmssy.wblabour.gov.in"
  )
)

# ---- Health ----
health <- data.frame(stringsAsFactors = FALSE,
  category = "Health",
  name_en = c("Swasthya Sathi", "Ayushman Bharat (PM-JAY)", "BM-SSY Medical Benefit"),
  name_bn = c("স্বাস্থ্য সাথী", "আয়ুষ্মান ভারত", ""),
  status = c("Live, continuing", "Approved for WB, rolling out (11 May 2026)", "Live"),
  benefit = c("Up to \u20b95 lakh/year cashless family health cover",
              "Up to \u20b95 lakh/year free hospital cover per family",
              "Financial help for major ailments incl. cancer, heart disease, kidney disease, TB"),
  apply = c("Apply online, or same-day enrolment with Aadhaar + address proof at a Duare Sarkar camp",
            "Check eligibility via national portal or nearest empanelled hospital / Common Service Centre",
            "Apply through BOCW Welfare Board registration"),
  contact = c("swasthyasathi.gov.in \u00b7 helpline 1800-111-009", "pmjay.gov.in", "Labour Dept, BOCW Welfare Board")
)

# ---- Food & Ration ----
food_ration <- data.frame(stringsAsFactors = FALSE,
  category = "Food & Ration",
  name_en = c("Ration Card (NFSA / Khadya Sathi)", "One Nation One Ration Card (ONORC)",
              "Pradhan Mantri Garib Kalyan Anna Yojana"),
  name_bn = c("রেশন কার্ড", "", ""),
  status = c("Live \u2014 mass re-verification underway following SIR electoral roll revision; ~63 lakh cards flagged for review/cancellation as of June 2026",
             "Live", "Live"),
  benefit = c("Subsidised food grains under NFSA", "Portability of ration entitlement across any state",
              "Additional free foodgrain allocation on top of NFSA"),
  apply = c("Apply for a new card, or check if your card is affected, via the Food & Supplies Dept portal",
            "Automatic once Aadhaar-linked at any e-PoS enabled shop",
            "Automatic for NFSA cardholders"),
  contact = c("food.wb.gov.in \u00b7 wbpds.gov.in \u00b7 helpline 1967 / 1800-345-5505",
              "helpline 14445", "Local FPS dealer")
)

# ---- Farmers & Agriculture ----
farmers <- data.frame(stringsAsFactors = FALSE,
  category = "Farmers & Agriculture",
  name_en = c("PM Kisan Samman Nidhi (+ state top-up)", "Krishak Bandhu Prakalpa",
              "Kisan Credit Card (KCC)", "Agriculture Infrastructure Fund (AIF)",
              "Soil Health Card", "Financial Support for Farm Mechanization",
              "One Time Assistance for Small Farm Implements", "PM Kisan Maandhan Yojana",
              "Farm Machinery Bank/Hub", "West Bengal Fishermen Welfare Scheme"),
  name_bn = c("পিএম কিষাণ", "কৃষক বন্ধু", "", "", "", "", "", "", "", ""),
  status = c("Rolling out in WB (previously excluded over land-record sharing; block being lifted)",
             "Live", "Live", "Live (originally FY2020-21 to FY2025-26)", "Live", "Live", "Live", "Live", "Live", "Live"),
  benefit = c("\u20b96,000/year central + ~\u20b93,000/year expected state top-up",
              "\u20b910,000/acre/year (max \u20b920,000) + \u20b92 lakh death insurance",
              "Crop loan at 4% interest up to \u20b93 lakh",
              "3% interest subvention + credit guarantee up to \u20b92 crore for post-harvest infrastructure",
              "Free soil testing and fertiliser recommendation",
              "Subsidy for power-operated farm equipment for small/marginal farmers",
              "Support for manually operated small farm implements",
              "\u20b93,000/month pension after 60, government-matched contribution",
              "Subsidised access to shared farm machinery",
              "\u20b95 lakh sea accident insurance + \u20b91,500/month lean-season allowance + diesel/ice subsidy"
  ),
  apply = c("PM-Kisan portal with land records + Aadhaar; local Krishi Bhavan can verify land documents",
            "Local Krishi Bhavan / Agriculture Dept office", "Any commercial or cooperative bank",
            "Through lending institution (commercial bank, cooperative bank, NBFC) + Project Management Unit support",
            "Local Krishi Bhavan", "Agriculture Department", "Agriculture Department",
            "PM-Kisan portal or Common Service Centre", "Agriculture Department", "Fisheries Department"
  ),
  contact = c("pmkisan.gov.in \u00b7 local Krishi Bhavan", "Krishi Bhavan", "Any bank branch",
              "Agriculture Dept, WB", "Krishi Bhavan", "Agriculture Dept", "Agriculture Dept",
              "pmkisan.gov.in", "Agriculture Dept", "Fisheries Dept, WB")
)

# ---- Employment & Youth ----
employment <- data.frame(stringsAsFactors = FALSE,
  category = "Employment & Youth",
  name_en = c("Bhorsa Karmasathi Scheme (formerly Banglar Yuva Sathi)", "Yuvashree Arpan / Employment Bank",
              "MGNREGA / Job Card", "PM Vishwakarma Yojana", "PM Kaushal Vikas Yojana (PMKVY 4.0)",
              "PM Internship Scheme", "Karma Sathi Prakalpa", "Taruner Swapno (two-wheeler subsidy)",
              "PM DAKSH Yojana", "PM Mudra Yojana", "PM SVANidhi", "DAY-NRLM Ajeevika",
              "DDU-GKY", "National Apprenticeship Promotion Scheme (NAPS)", "Agniveer Scheme"),
  name_bn = c("ভরসা কর্মসাথী", "যুবশ্রী", "", "", "", "", "কর্মসাথী প্রকল্প", "তরুণের স্বপ্ন", "", "", "", "", "", "", ""),
  status = c("Announced, June 2026 budget", "Live", "Live", "Rolled out from May 2026", "Live",
             "Live", "Live", "Live", "Live", "Live", "Live", "Live", "Live", "Live", "Live"),
  benefit = c("\u20b93,000/month while job-seeking, for unemployed WB youth",
              "\u20b91,500/month unemployment allowance + training/job fair access",
              "100 days guaranteed work at ~\u20b9237-267/day",
              "Skill training + toolkit allowance + collateral-free loans for traditional trades",
              "Free skill training + NSQF certificate + \u20b98,000 completion bonus",
              "\u20b99,000/month stipend + \u20b96,000 travel grant + \u20b92 lakh accident insurance",
              "\u20b92 lakh interest-free self-employment loan, 18-45 yrs",
              "Up to \u20b91 lakh (25%) subsidy on two-wheeler for youth self-employment",
              "Free skill training + \u20b91,000-3,000/month stipend for SC/ST/OBC/minorities",
              "Collateral-free business loan \u20b950,000 to \u20b920 lakh",
              "Collateral-free working capital loan for street vendors",
              "SHG revolving fund + bank loan up to \u20b93 lakh at subsidised rates",
              "Skill training + placement for rural poor youth",
              "Stipend support during apprenticeship",
              "\u20b930,000-40,000/month + \u20b911.71 lakh Seva Nidhi after 4 years, defence recruitment"
  ),
  apply = c("Employment/Labour Dept once formally notified", "WB Employment Bank portal",
            "Gram Panchayat / Block office", "National portal + proof of trade; CSCs assist",
            "Nearest PMKVY training centre", "PM Internship portal",
            "Employment Bank / Karma Sathi portal", "Youth self-employment scheme portal via block office",
            "Skill Development Dept", "Any bank / MUDRA portal", "Urban Local Body / bank",
            "Block-level NRLM office", "DDU-GKY portal", "NAPS portal via employer", "Indian Armed Forces recruitment portal"
  ),
  contact = c("Employment/Labour Dept, WB", "wbemploymentbank.gov.in", "Gram Panchayat office",
              "pmvishwakarma.gov.in", "pmkvyofficial.org", "pminternship.mca.gov.in",
              "Employment Bank office", "Block Development Office", "Skill Dev Dept",
              "Any bank branch", "Urban Local Body office", "nulm.gov.in / block NRLM office",
              "ddugky.gov.in", "apprenticeshipindia.gov.in", "joinindianarmy.nic.in"
  )
)

# ---- Education & Scholarships ----
education <- data.frame(stringsAsFactors = FALSE,
  category = "Education & Scholarships",
  name_en = c("Vivekananda Merit-cum-Means Scholarship (SVMCM)", "Shikshashree Scheme (SC, Class V-VIII)",
              "Aikyashree Scholarship (minority students)", "Sabooj Sathi (free bicycles)",
              "WB Student Credit Card Scheme", "West Bengal SC/ST Post-Matric Scholarship",
              "WB OBC Scholarship", "WB Pre-Matric Scholarship SC/ST", "WB Tapasi Prakalpa (SC/ST girls, Class 10)",
              "WB Nabanna Scholarship (tea garden workers' children)", "National Scholarship Portal (NSP)",
              "West Bengal Freeship Scheme", "West Bengal Medhashree Scheme"),
  name_bn = c("স্বামী বিবেকানন্দ বৃত্তি", "শিক্ষাশ্রী", "ঐক্যশ্রী বৃত্তি", "সবুজ সাথী", "", "", "", "", "তপশী প্রকল্প", "নবান্ন বৃত্তি", "", "", ""),
  status = rep("Live", 13),
  benefit = c("\u20b91,000-5,000/month, Class 11 to PhD, merit + income based",
              "Financial assistance for SC students Class V-VIII",
              "\u20b91,100-12,000/year depending on level, minority students",
              "Free bicycle for Class 9-12 students in govt/aided schools",
              "Education loan up to \u20b910 lakh at 4%, no collateral, no guarantor",
              "Full tuition + \u20b9350-1,200/month maintenance, Class 11 to professional degree",
              "Full tuition + \u20b9500-1,200/month maintenance for OBC-A/B students",
              "\u20b9150-750/month + tuition waiver, Class 9-10",
              "\u20b910,000 one-time award on passing Class 10",
              "\u20b95,000-10,000/year, Class 5-12",
              "\u20b91,000-20,000/year depending on category/level",
              "Tuition fee waiver for UG Engineering/Pharmacy/Architecture students",
              "State merit scholarship scheme"
  ),
  apply = c("SVMCM portal via school/college", "School nodal officer", "Aikyashree portal",
            "School, automatic for eligible classes", "wbscc.wb.gov.in via bank",
            "School/college + caste certificate", "School/college", "School",
            "School on passing Madhyamik", "School + tea garden worker ID",
            "scholarships.gov.in", "Higher Education Dept via college", "Higher Education Dept"
  ),
  contact = c("svmcm.wbhed.gov.in", "Local school", "wbmdfcskillmission.org", "School education office",
              "Any nationalised bank + wbscc.wb.gov.in", "Backward Classes Welfare Dept",
              "Backward Classes Welfare Dept", "Backward Classes Welfare Dept", "Backward Classes Welfare Dept",
              "Labour Dept / school", "scholarships.gov.in helpline", "wbhed.gov.in", "wbhed.gov.in"
  )
)

# ---- Housing ----
housing <- data.frame(stringsAsFactors = FALSE,
  category = "Housing",
  name_en = c("PM Awas Yojana (Gramin & Urban)", "Banglar Bari / Banglar Awaas Yojana",
              "WB Aamar Bari Aamar Gram", "Akanksha Housing Scheme (govt employees)",
              "Pratyasha Scheme (police housing)"),
  name_bn = c("", "বাংলার বাড়ি", "আমার বাড়ি আমার গ্রাম", "", ""),
  status = rep("Live", 5),
  benefit = c("PMAY-G ~\u20b91.2-1.3 lakh + PMAY-U interest subsidy up to \u20b92.67 lakh",
              "Free/subsidised housing for urban poor, slum dwellers, EWS/BPL",
              "Road + drinking water + electricity + housing support for remote villages",
              "Housing for serving state government employees",
              "Housing for WB Police personnel (Inspector to Constable)"
  ),
  apply = c("PMAY portal / local ULB", "Municipal / Urban Development office",
            "Gram Panchayat / Rural Development Dept", "Housing Department", "WB Police Housing Corporation"),
  contact = c("pmayg.nic.in / pmay-urban.gov.in", "Urban Development Dept, WB",
              "Panchayat & Rural Development Dept", "Housing Dept, WB", "WB Police HQ")
)

# ---- Pension & Disability ----
pension_disability <- data.frame(stringsAsFactors = FALSE,
  category = "Pension & Disability",
  name_en = c("Jai Bangla Pension (Manabik / Jai Johar)", "Atal Pension Yojana",
              "Taposili Bandhu Scheme", "BOCW Pension Benefit"),
  name_bn = c("জয় বাংলা পেনশন", "", "তপশিলি বন্ধু", ""),
  status = rep("Live", 4),
  benefit = c("\u20b91,000/month \u2014 Manabik (60%+ disability) + Jai Johar (SC/ST elderly 60+)",
              "\u20b91,000-5,000/month guaranteed pension after age 60, with govt co-contribution for eligible subscribers",
              "Old-age pension for Backward Classes", "Monthly pension after 60 for registered construction workers"),
  apply = c("BDO/Municipality office", "Any bank or post office savings account",
            "Backward Classes Welfare Dept", "BOCW Welfare Board"),
  contact = c("Social Welfare Dept, WB", "npscra.proteantech.in", "Backward Classes Welfare Dept", "bocwwbwb.gov.in")
)

# ---- Financial Inclusion & Identity ----
finance_identity <- data.frame(stringsAsFactors = FALSE,
  category = "Financial Inclusion & Identity",
  name_en = c("Aadhaar Enrolment & Seeding", "PM Jan Dhan Yojana", "E-Shram Card", "Udyam Registration",
              "PM Suraksha Bima Yojana", "PM Jeevan Jyoti Bima Yojana", "PM Shram Yogi Maandhan"),
  name_bn = c("আধার নথিভুক্তকরণ ও সিডিং", "", "", "", "", "", ""),
  status = rep("Live", 7),
  benefit = c("Foundational identity + DBT linkage \u2014 required for almost every other scheme on this list",
              "Zero-balance account + \u20b92 lakh accident insurance + \u20b910,000 overdraft",
              "\u20b92 lakh accident insurance + priority in PMAY, Ujjwala, Ayushman Bharat for unorganised workers",
              "Formal MSME registration, needed for many business incentive schemes below",
              "\u20b92 lakh accidental death/disability cover, ~\u20b920/year premium",
              "\u20b92 lakh life cover, ~\u20b9436/year premium",
              "\u20b93,000/month pension for unorganised workers after 60"
  ),
  apply = c("Nearest Aadhaar Enrolment Centre", "Any bank branch", "eshram.gov.in or CSC",
            "udyamregistration.gov.in", "Any bank offering the scheme", "Any bank offering the scheme", "CSC or LIC"),
  contact = c("uidai.gov.in", "pmjdy.gov.in", "eshram.gov.in", "udyamregistration.gov.in",
              "Any nationalised bank", "Any nationalised bank", "maandhan.in")
)

# ---- Energy & Infrastructure ----
energy <- data.frame(stringsAsFactors = FALSE,
  category = "Energy & Infrastructure",
  name_en = c("PM Surya Ghar Muft Bijli Yojana"),
  name_bn = c(""),
  status = c("Open for applications in WB"),
  benefit = c("Rooftop solar subsidy, aimed at free/near-free monthly electricity, up to \u20b978,000 subsidy"),
  apply = c("National solar portal using WBSEDCL consumer number; empanelled vendors handle installation"),
  contact = c("pmsuryaghar.gov.in")
)

# ---- Business & MSME Incentives (grouped; brief, not citizen-facing troubleshooting) ----
msme <- data.frame(stringsAsFactors = FALSE,
  category = "Business & MSME Incentives",
  name_en = c(
    "Banglashree for MSMEs (Interest Subsidy on Term Loan)",
    "Banglashree for MSMEs (Workforce Welfare Assistance)",
    "Banglashree for MSMEs (Energy Efficiency Subsidy)",
    "Banglashree for MSMEs (Capital Investment Subsidy)",
    "Banglashree for MSMEs (Stamp Duty/Registration Fee Subsidy)",
    "Banglashree for MSMEs (Power Subsidy)",
    "Banglashree for MSMEs (Water Conservation Subsidy)",
    "Banglashree for MSMEs (Standard Quality Compliance Subsidy)",
    "The West Bengal Incentive Scheme (Tourism: interest subsidy, capital subsidy, electricity/stamp duty waivers, employment incentive)",
    "West Bengal Textile Incentive Scheme (energy, water, power, capital, stamp duty components)",
    "Incentive Scheme for MSMEs in Powerloom Sector (multiple components: stamp duty, SGST, power, quality, patent)",
    "SAIP for MSMEs (industrial park infrastructure incentives)",
    "West Bengal Handloom & Khadi Weavers Financial Benefit Scheme 2024",
    "West Bengal Artisans Financial Benefit Scheme 2024",
    "PM Mudra Yojana (business loan, also listed above)",
    "PM Formalisation of Micro Food Processing Enterprises (PM-FME)"
  ),
  name_bn = rep("", 16),
  status = rep("Live", 16),
  benefit = c(
    "Interest subsidy on term loans for eligible micro/small enterprises",
    "Reimbursement of ESI/EPF contributions",
    "Reimbursement for energy conservation installations per audit",
    "Capital investment subsidy for approved projects",
    "Reimbursement of stamp duty and registration fees",
    "Power subsidy on electricity consumed for manufacturing",
    "Reimbursement for effluent treatment / water conservation infrastructure",
    "Reimbursement for certification (ISI/BIS/ISO)",
    "Multiple incentives for approved tourism sector projects",
    "Multiple incentives for textile sector units",
    "Multiple incentives specific to powerloom units",
    "Infrastructure development support for approved industrial parks",
    "Support for handloom/khadi weaver cooperative societies (yarn subsidy, NPA settlement, viability support)",
    "Support for artisans and industrial cooperative societies (tool kits, digital marketing, facilitation)",
    "Collateral-free loan \u20b950,000-20 lakh for MSMEs",
    "Support for micro food processing enterprise formalisation"
  ),
  apply = rep("MSME & Textiles Dept / relevant nodal department; consult a District Industries Centre for eligibility and paperwork", 16),
  contact = rep("MSME & Textiles Dept, Govt of WB \u00b7 District Industries Centre", 16)
)

all_schemes <- rbind(women_family, health, food_ration, farmers, employment,
                      education, housing, pension_disability, finance_identity,
                      energy, msme)

# quick integrity check when sourced interactively
if (interactive()) {
  cat("Loaded", nrow(all_schemes), "schemes across", length(unique(all_schemes$category)), "categories\n")
}