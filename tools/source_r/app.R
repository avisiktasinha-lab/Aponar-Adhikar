########################################################################
# Aponar Adhikar — West Bengal scheme troubleshooting + directory (R Shiny)
#
# Two tools in one app:
#   Tab 1, "Fix a problem": a Bengali-first triage wizard for the small
#     set of high-volume schemes people actually get stuck on after
#     enrolling — Annapurna Bhandar (formerly Lakshmir Bhandar),
#     Swasthya Sathi, and Ration Card/NFSA (incl. the 2026 SIR
#     re-verification issue). This is the differentiated part: existing
#     directories help people apply, not people who already applied and
#     are stuck.
#   Tab 2, "Browse all schemes": a searchable directory of ~90 schemes
#     compiled from WB state schemes, applicable central schemes, and
#     MSME/business incentives — name, benefit, status, how to apply,
#     and contact info. No troubleshooting logic here, just facts.
#
# NOTE (as of writing): West Bengal's state government changed in 2026.
# Several scheme names/rules below reflect that transition (Lakshmir
# Bhandar -> Annapurna Bhandar, Ayushman Bharat now live in WB, the SIR
# ration-card re-verification). Re-verify against official sources
# before wide release — these details move fast.
#
# To run locally:
#   install.packages("shiny")
#   shiny::runApp("app.R")
#
# To deploy for real people to use (free tier available):
#   install.packages("rsconnect")
#   rsconnect::deployApp("path/to/this/folder")
########################################################################

library(shiny)
source("schemes_data.R")

# ============================================================
# 1. CONTENT — troubleshooting tree for the high-volume schemes.
#    Edit/extend this list to add schemes or refine steps.
# ============================================================

content <- list(

  annapurna = list(
    name_bn = "\u0985\u09a8\u09cd\u09a8\u09aa\u09c2\u09b0\u09cd\u09a3\u09be \u09ad\u09be\u09a3\u09cd\u09a1\u09be\u09b0",
    name_en = "Annapurna Bhandar (formerly Lakshmir Bhandar)",
    note_bn = "\u098f\u0987 \u09b8\u09cd\u0995\u09bf\u09ae\u099f\u09bf \u09b2\u0995\u09cd\u09b7\u09cd\u09ae\u09c0\u09b0 \u09ad\u09be\u09a3\u09cd\u09a1\u09be\u09b0 \u09a5\u09c7\u0995\u09c7 \u09aa\u09b0\u09bf\u09ac\u09b0\u09cd\u09a4\u09bf\u09a4 \u2014 \u09aa\u09c1\u09b0\u09a8\u09cb \u0989\u09aa\u09ad\u09cb\u0995\u09cd\u09a4\u09be\u09b0\u09be \u09b8\u09cd\u09ac\u09df\u0982\u0995\u09cd\u09b0\u09bf\u09df\u09ad\u09be\u09ac\u09c7 \u09b8\u09cd\u09a5\u09be\u09a8\u09be\u09a8\u09cd\u09a4\u09b0\u09bf\u09a4 \u09a7\u09b0\u09c7 \u09a8\u09c7\u09ac\u09c7\u09a8 \u09a8\u09be, status \u09af\u09be\u099a\u09be\u0987 \u0995\u09b0\u09c1\u09a8\u0964",
    note_en = "This scheme transitioned from Lakshmir Bhandar in June 2026 \u2014 don't assume migration happened automatically, confirm your status.",

    issues = list(

      no_payment = list(
        label_bn = "\u098f\u0987 \u09ae\u09be\u09b8\u09c7 \u099f\u09be\u0995\u09be \u0986\u09b8\u09c7\u09a8\u09bf",
        label_en = "This month's money hasn't come",
        question_bn = "\u0986\u09aa\u09a8\u09bf \u0995\u09bf \u0986\u0997\u09c7 \u0995\u09cb\u09a8\u09cb \u09ae\u09be\u09b8\u09c7\u09b0 \u099f\u09be\u0995\u09be \u09aa\u09c7\u09df\u09c7\u099b\u09c7\u09a8?",
        question_en = "Have you received the payment in any earlier month?",
        options = list(

          never = list(
            label_bn = "\u09a8\u09be, \u0995\u0996\u09a8\u09cb \u09aa\u09be\u0987\u09a8\u09bf \u2014 \u098f\u099f\u09be \u09a8\u09a4\u09c1\u09a8 \u0986\u09ac\u09c7\u09a6\u09a8",
            label_en = "No, never \u2014 this is a new application",
            diagnosis_bn = "\u09a8\u09a4\u09c1\u09a8 \u0986\u09ac\u09c7\u09a6\u09a8 \u0985\u09a8\u09c1\u09ae\u09cb\u09a6\u09a8 \u09b9\u09a4\u09c7 \u09b8\u09be\u09a7\u09be\u09b0\u09a3\u09a4 \u0995\u09df\u09c7\u0995 \u09b8\u09aa\u09cd\u09a4\u09be\u09b9 \u09a5\u09c7\u0995\u09c7 \u09e8-\u09e9 \u09ae\u09be\u09b8 \u09b8\u09ae\u09df \u09b2\u09be\u0997\u09c7\u0964",
            diagnosis_en = "New applications typically take a few weeks to 2-3 months for approval. This isn't necessarily a problem yet, but confirm the application status.",
            steps_bn = c(
              "BDO/SDO অফিসে বা সামাজিক নিবন্ধন পোর্টালে আপনার আবেদনের status যাচাই করুন।",
              "নিশ্চিত করুন আপনার স্বাস্থ্য সাথী কার্ড আছে কিনা।",
              "আধার-লিঙ্কড ব্যাঙ্ক অ্যাকাউন্ট আছে কিনা যাচাই করুন — টাকা এই অ্যাকাউন্টেই আসবে।"
            ),
            steps_en = c(
              "Check your application status at the BDO/SDO office or on the social registry portal.",
              "Confirm you have a Swasthya Sathi card.",
              "Check that your bank account is Aadhaar-linked — the payment will only go to this account."
            )
          ),

          stopped = list(
            label_bn = "\u0986\u0997\u09c7 \u09aa\u09c7\u09df\u09c7\u099b\u09bf, \u098f\u0996\u09a8 \u09ac\u09a8\u09cd\u09a7 \u09b9\u09df\u09c7 \u0997\u09c7\u099b\u09c7",
            label_en = "I received it before, but it has now stopped",
            diagnosis_bn = "\u09b8\u09ac\u099a\u09c7\u09df\u09c7 \u09b8\u09be\u09a7\u09be\u09b0\u09a3 \u0995\u09be\u09b0\u09a3 \u09b9\u09b2\u09cb \u0986\u09a7\u09be\u09b0-\u09ac\u09cd\u09af\u09be\u0982\u0995 \u09b8\u09bf\u09a1\u09bf\u0982 \u09ad\u09c7\u0999\u09c7 \u09af\u09be\u0993\u09df\u09be, \u09a8\u09be\u09ae\u09c7\u09b0 \u0985\u09ae\u09bf\u09b2, \u0985\u09a5\u09ac\u09be \u09b2\u0995\u09cd\u09b7\u09cd\u09ae\u09c0\u09b0 \u09ad\u09be\u09a3\u09cd\u09a1\u09be\u09b0 \u09a5\u09c7\u0995\u09c7 \u0985\u09a8\u09cd\u09a8\u09aa\u09c2\u09b0\u09cd\u09a3\u09be \u09ad\u09be\u09a3\u09cd\u09a1\u09be\u09b0\u09c7 \u09aa\u09b0\u09bf\u09ac\u09b0\u09cd\u09a4\u09a8\u09c7\u09b0 migration audit-\u098f \u09ac\u09be\u09a6 \u09aa\u09dc\u09be\u0964",
            diagnosis_en = "The most common causes are broken Aadhaar-bank seeding, a name mismatch, or being dropped during the Lakshmir Bhandar to Annapurna Bhandar migration audit (e.g. the age floor moved from 21 to 25).",
            steps_bn = c(
              "ব্যাঙ্ক শাখায় গিয়ে আধার এই অ্যাকাউন্টের সাথেই seeded আছে কিনা যাচাই করুন — myaadhaar.uidai.gov.in-এও Bank Seeding Status চেক করা যায়।",
              "ব্যাঙ্ক পাসবই, স্বাস্থ্য সাথী কার্ড ও আধার কার্ডে নামের বানান একই কিনা মিলিয়ে দেখুন।",
              "বয়স ২১-২৪ হলে লক্ষ্য রাখুন — নতুন প্রকল্পের বয়সসীমা ২৫, তাই সাময়িকভাবে বাদ পড়ে থাকতে পারেন। ২৫ বছর হলে পুনরায় আবেদন করুন।",
              "৩ মাসের বেশি দেরি হলে BDO বা District Social Welfare Officer-কে RTI করার কথা ভাবুন — আবেদন নম্বর দিয়ে reason of delay জিজ্ঞাসা করুন।"
            ),
            steps_en = c(
              "Visit your bank branch and confirm Aadhaar is seeded to this exact account — you can also check Bank Seeding Status at myaadhaar.uidai.gov.in.",
              "Check that your name is spelled identically on your bank passbook, Swasthya Sathi card, and Aadhaar card.",
              "If you're 21-24, note the new scheme's floor is 25 — you may have been dropped temporarily and should reapply once you turn 25.",
              "If delayed more than 3 months, consider filing an RTI with the BDO or District Social Welfare Officer asking for the reason for delay, citing your application number."
            )
          )
        )
      ),

      rejected = list(
        label_bn = "\u0986\u09ac\u09c7\u09a6\u09a8 \u09ac\u09be\u09a4\u09bf\u09b2 \u09b9\u09df\u09c7 \u0997\u09c7\u099b\u09c7",
        label_en = "My application was rejected",
        question_bn = "\u09aa\u09cd\u09b0\u09a4\u09cd\u09af\u09be\u0996\u09cd\u09af\u09be\u09a8\u09c7\u09b0 \u0995\u09be\u09b0\u09a3 \u09b9\u09bf\u09b8\u09c7\u09ac\u09c7 \u0995\u09c0 \u09ac\u09b2\u09be \u09b9\u09df\u09c7\u099b\u09c7?",
        question_en = "What reason was given for the rejection?",
        options = list(

          no_reason = list(
            label_bn = "\u0995\u09cb\u09a8\u09cb \u0995\u09be\u09b0\u09a3 \u09ac\u09b2\u09be \u09b9\u09df\u09a8\u09bf",
            label_en = "No reason was given",
            diagnosis_bn = "\u0995\u09be\u09b0\u09a3 \u099b\u09be\u09a1\u09bc\u09be \u09aa\u09cd\u09b0\u09a4\u09cd\u09af\u09be\u0996\u09cd\u09af\u09be\u09a8 \u0985\u09a8\u09c7\u0995 \u09b8\u09ae\u09df \u09a8\u09a5\u09bf\u09b0 \u0985\u09ae\u09bf\u09b2 \u09ac\u09be \u0985\u09b8\u09ae\u09cd\u09aa\u09c2\u09b0\u09cd\u09a3 \u09a4\u09a5\u09cd\u09af\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u09b9\u09df\u09c7 \u09a5\u09be\u0995\u09c7\u0964",
            diagnosis_en = "A rejection without a stated reason is often due to a document mismatch or incomplete information.",
            steps_bn = c(
              "BDO/SDO অফিসে গিয়ে সরাসরি রিজেকশনের কারণ লিখিতভাবে জানতে চান।",
              "আধার, ভোটার/রেশন কার্ড, স্বাস্থ্য সাথী কার্ড ও ব্যাঙ্ক পাসবইয়ে নাম ও বয়সের তথ্য একই আছে কিনা মিলিয়ে দেখুন।",
              "সব নথি ঠিক থাকলে পুনরায় আবেদন করুন।"
            ),
            steps_en = c(
              "Go to the BDO/SDO office and ask directly for the rejection reason in writing.",
              "Cross-check that your name and age match exactly across Aadhaar, voter/ration card, Swasthya Sathi card, and bank passbook.",
              "If all documents check out, reapply."
            )
          ),

          age = list(
            label_bn = "\u09ac\u09df\u09b8 \u09e8\u09eb-\u09ec\u09e6 \u09ac\u099b\u09b0\u09c7\u09b0 \u09ae\u09a7\u09cd\u09af\u09c7 \u09a8\u09df",
            label_en = "Age is outside the 25-60 range",
            diagnosis_bn = "Annapurna Bhandar-\u098f \u09ac\u09df\u09b8\u09b8\u09c0\u09ae\u09be \u09e8\u09eb \u09a5\u09c7\u0995\u09c7 \u09ec\u09e6 \u2014 \u098f\u099f\u09be \u09aa\u09c1\u09b0\u09a8\u09cb \u09b2\u0995\u09cd\u09b7\u09cd\u09ae\u09c0\u09b0 \u09ad\u09be\u09a3\u09cd\u09a1\u09be\u09b0\u09c7\u09b0 \u09e8\u09e7 \u09ac\u099b\u09b0 \u09a5\u09c7\u0995\u09c7 \u0985\u09a8\u09c7\u0995 \u09ac\u09c7\u09b6\u09bf\u0964",
            diagnosis_en = "Annapurna Bhandar's age window is 25-60, higher than Lakshmir Bhandar's old floor of 21.",
            steps_bn = c(
              "আধার কার্ডে জন্মতারিখ ভুল থাকলে UIDAI-তে সংশোধন করান, তারপর পুনরায় আবেদন করুন।",
              "সঠিক হলে ২৫ বছর পূর্ণ হওয়ার পর পুনরায় আবেদন করার কথা মনে রাখুন।"
            ),
            steps_en = c(
              "If your Aadhaar has an incorrect date of birth, correct it with UIDAI first, then reapply.",
              "If correct, note the date you'll turn 25 and reapply then."
            )
          ),

          no_card = list(
            label_bn = "\u09b8\u09cd\u09ac\u09be\u09b8\u09cd\u09a5\u09cd\u09af \u09b8\u09be\u09a5\u09c0 \u0995\u09be\u09b0\u09cd\u09a1 \u09a8\u09c7\u0987",
            label_en = "No Swasthya Sathi card",
            diagnosis_bn = "\u098f\u0987 \u0995\u09be\u09b0\u09cd\u09a1 \u099b\u09be\u09a1\u09bc\u09be \u0986\u09ac\u09c7\u09a6\u09a8 \u098f\u0997\u09cb\u09df \u09a8\u09be, \u0995\u09bf\u09a8\u09cd\u09a4\u09c1 \u098f\u099f\u09be \u09ac\u09bf\u09a8\u09be\u09ae\u09c2\u09b2\u09cd\u09af\u09c7 \u09aa\u09be\u0993\u09df\u09be \u09af\u09be\u09df\u0964",
            diagnosis_en = "This scheme cannot proceed without a Swasthya Sathi card, but it's free and straightforward to get.",
            steps_bn = c(
              "Duare Sarkar ক্যাম্পে বিনামূল্যে স্বাস্থ্য সাথী কার্ডের জন্য আবেদন করুন — আধার ও পরিবারের তথ্য সাথে রাখুন।",
              "কার্ড হাতে পাওয়ার পর আবেদন পুনরায় জমা দিন বা আপডেট করান।"
            ),
            steps_en = c(
              "Apply for a Swasthya Sathi card, free, at a Duare Sarkar camp — bring Aadhaar and family details.",
              "Once you have the card, resubmit or update your application."
            )
          ),

          govt_job = list(
            label_bn = "\u09aa\u09b0\u09bf\u09ac\u09be\u09b0\u09c7 \u09b8\u09b0\u0995\u09be\u09b0\u09bf \u099a\u09be\u0995\u09b0\u09bf\u099c\u09c0\u09ac\u09c0 \u0986\u099b\u09c7",
            label_en = "A government employee in the family",
            diagnosis_bn = "\u098f\u099f\u09be \u09b8\u09cd\u0995\u09bf\u09ae\u09c7\u09b0 \u09a8\u09bf\u09df\u09ae\u09c7\u09b0 \u0985\u0982\u09b6, \u09ad\u09c1\u09b2 \u09a8\u09df\u0964",
            diagnosis_en = "A government employee anywhere in the family disqualifies the household under this scheme's rules.",
            steps_bn = c(
              "এই কারণ সঠিক হলে, এই স্কিমে আপিলের সুযোগ নেই।",
              "অন্য প্রযোজ্য স্কিম আছে কিনা BDO অফিসে জিজ্ঞাসা করতে পারেন।"
            ),
            steps_en = c(
              "If accurate, there is no appeal route for this particular scheme.",
              "Ask at the BDO office whether other schemes apply to your household instead."
            )
          )
        )
      ),

      agent = list(
        label_bn = "\u0995\u09c7\u0989 \u0986\u09ac\u09c7\u09a6\u09a8\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u099f\u09be\u0995\u09be \u099a\u09be\u0987\u099b\u09c7",
        label_en = "Someone is asking for money to apply",
        question_bn = NULL, question_en = NULL, options = NULL, direct_warning = TRUE
      )
    )
  ),

  ration = list(
    name_bn = "\u09b0\u09c7\u09b6\u09a8 \u0995\u09be\u09b0\u09cd\u09a1 (NFSA)",
    name_en = "Ration Card (NFSA)",
    note_bn = "SIR \u09a8\u09bf\u09b0\u09cd\u09ac\u09be\u099a\u09a8\u09c0 \u09a4\u09be\u09b2\u09bf\u0995\u09be\u09b0 \u09b8\u0999\u09cd\u0997\u09c7 \u09af\u09c1\u0995\u09cd\u09a4 \u09b0\u09be\u099c\u09cd\u09af\u09ac\u09cd\u09af\u09be\u09aa\u09c0 \u09aa\u09c1\u09a8\u09b0\u09cd\u09af\u09be\u099a\u09be\u0987 \u099a\u09b2\u099b\u09c7 \u2014 \u09aa\u09cd\u09b0\u09be\u09df \u09ec\u09e9 \u09b2\u0995\u09cd\u09b7 \u0995\u09be\u09b0\u09cd\u09a1 \u09aa\u09b0\u09cd\u09af\u09be\u09b2\u09cb\u099a\u09a8\u09be\u09a7\u09c0\u09a8\u09c7\u0964",
    note_en = "A state-wide re-verification linked to the electoral roll revision (SIR) is underway \u2014 roughly 63 lakh cards are under review.",

    issues = list(

      no_ration = list(
        label_bn = "\u09a6\u09cb\u0995\u09be\u09a8\u09c7 \u09b0\u09c7\u09b6\u09a8 \u09aa\u09be\u099a\u09cd\u099b\u09bf \u09a8\u09be",
        label_en = "Not getting ration at the shop",
        question_bn = "\u09a6\u09cb\u0995\u09be\u09a8\u09c7 \u0997\u09c7\u09b2\u09c7 \u0995\u09c0 \u09b8\u09ae\u09b8\u09cd\u09af\u09be \u09b9\u09df?",
        question_en = "What happens when you go to the shop?",
        options = list(

          biometric_fail = list(
            label_bn = "\u0986\u0999\u09c1\u09b2\u09c7\u09b0 \u099b\u09be\u09aa (biometric) \u09ae\u09bf\u09b2\u099b\u09c7 \u09a8\u09be",
            label_en = "Fingerprint/biometric doesn't match",
            diagnosis_bn = "\u09ac\u09df\u09b8\u09cd\u0995 \u09ac\u09be \u0995\u09be\u09df\u09bf\u0995 \u09aa\u09b0\u09bf\u09b6\u09cd\u09b0\u09ae\u0995\u09be\u09b0\u09c0\u09a6\u09c7\u09b0 \u0995\u09cd\u09b7\u09c7\u09a4\u09cd\u09b0\u09c7 biometric \u09ac\u09cd\u09af\u09b0\u09cd\u09a5 \u09b9\u0993\u09df\u09be \u098f\u0995\u099f\u09bf \u09b8\u09c1\u09aa\u09b0\u09bf\u099a\u09bf\u09a4 \u09b8\u09ae\u09b8\u09cd\u09af\u09be \u2014 \u098f\u099f\u09be \u0986\u09aa\u09a8\u09be\u09b0 \u09a4\u09cd\u09b0\u09c1\u099f\u09bf \u09a8\u09df\u0964",
            diagnosis_en = "Biometric authentication failure is well-documented for elderly people and manual laborers — this is not your fault.",
            steps_bn = c(
              "ডিলারকে exception/manual override দিয়ে রেশন দিতে বলুন — এই ব্যবস্থা নিয়মে আছে।",
              "OTP-ভিত্তিক যাচাইয়ের বিকল্প আছে কিনা জিজ্ঞাসা করুন।",
              "সমস্যা চলতে থাকলে খাদ্য ও সরবরাহ দপ্তরের হেল্পলাইনে অভিযোগ জানান — 1967 বা 1800-345-5505।"
            ),
            steps_en = c(
              "Ask the dealer for a manual exception/override — this provision exists for exactly this situation.",
              "Ask if OTP-based verification is available instead.",
              "If it continues, complain to the Food & Supplies helpline — 1967 or 1800-345-5505."
            )
          ),

          sir_review = list(
            label_bn = "\u0995\u09be\u09b0\u09cd\u09a1 SIR-\u098f \u09ac\u09be\u09a4\u09bf\u09b2\u09c7\u09b0 \u09a4\u09be\u09b2\u09bf\u0995\u09be\u09df \u0986\u099b\u09c7 \u09ac\u09b2\u09c7 \u09b6\u09c1\u09a8\u09c7\u099b\u09bf",
            label_en = "I've heard my card is on the SIR cancellation review list",
            diagnosis_bn = "\u09aa\u09cd\u09b0\u09be\u09df \u09ec\u09e9 \u09b2\u0995\u09cd\u09b7 \u0995\u09be\u09b0\u09cd\u09a1 \u09aa\u09c1\u09a8\u09b0\u09cd\u09af\u09be\u099a\u09be\u0987\u09df\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u099a\u09bf\u09b9\u09cd\u09a8\u09bf\u09a4 \u2014 \u09a4\u09be\u09b2\u09bf\u0995\u09be\u09df \u09a5\u09be\u0995\u09be \u09ae\u09be\u09a8\u09c7\u0987 \u0995\u09be\u09b0\u09cd\u09a1 \u09ac\u09be\u09a4\u09bf\u09b2 \u09a8\u09df, \u0995\u09bf\u09a8\u09cd\u09a4\u09c1 \u09a6\u09cd\u09b0\u09c1\u09a4 \u09aa\u09a6\u0995\u09cd\u09b7\u09c7\u09aa \u09a8\u09c7\u0993\u09df\u09be \u099c\u09b0\u09c1\u09b0\u09bf\u0964 \u0995\u09c7\u0989 \u0995\u09c7\u0989 \u09b8\u09a0\u09bf\u0995 \u09ad\u09cb\u099f\u09be\u09b0 \u09ac\u09bf\u09a8\u09be \u0995\u09be\u09b0\u09a3\u09c7\u0993 \u09ad\u09c1\u09b2\u09ac\u09b6\u09a4 \u09a4\u09be\u09b2\u09bf\u0995\u09be\u09df \u09aa\u09dc\u09c7\u099b\u09c7\u09a8 \u09ac\u09b2\u09c7 \u0985\u09ad\u09bf\u09af\u09cb\u0997 \u0986\u099b\u09c7\u0964",
            diagnosis_en = "About 63 lakh cards are flagged for re-verification. Being on the list doesn't automatically mean cancellation — but acting quickly matters. There are also credible reports of genuine cardholders being wrongly flagged due to spelling mismatches or data errors, unrelated to actual eligibility.",
            steps_bn = c(
              "খাদ্য ও সরবরাহ দপ্তরের পোর্টালে (food.wb.gov.in) বা স্থানীয় FPS-এ গিয়ে কার্ডের status নিশ্চিত করুন।",
              "নথি (আধার, ঠিকানার প্রমাণ) নিয়ে নির্ধারিত সময়ের মধ্যে re-verification সম্পূর্ণ করুন।",
              "যদি ভোটার তালিকা থেকে ভুলবশত নাম বাদ পড়ে থাকে বলে মনে হয়, তাহলে Tribunal-এ আপিল করুন — আপিল বিচারাধীন থাকাকালীন রেশন সুবিধা চালু থাকার কথা।",
              "কারণ ছাড়া কার্ড বাতিল হয়ে থাকলে BDO/SDO অফিসে লিখিত আপিল জমা দিন।"
            ),
            steps_en = c(
              "Confirm your card's status on the Food & Supplies portal (food.wb.gov.in) or at your local FPS.",
              "Complete re-verification within the notified deadline with your documents (Aadhaar, address proof).",
              "If you believe your name was wrongly removed from the voter list, file a tribunal appeal — benefits are meant to continue while an appeal is pending.",
              "If your card has already been cancelled without clear reason, file a written appeal at the BDO/SDO office."
            )
          )
        )
      ),

      agent = list(
        label_bn = "\u0995\u09c7\u0989 \u0986\u09ac\u09c7\u09a6\u09a8\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u099f\u09be\u0995\u09be \u099a\u09be\u0987\u099b\u09c7",
        label_en = "Someone is asking for money to apply",
        question_bn = NULL, question_en = NULL, options = NULL, direct_warning = TRUE
      )
    )
  ),

  swasthya = list(
    name_bn = "\u09b8\u09cd\u09ac\u09be\u09b8\u09cd\u09a5\u09cd\u09af \u09b8\u09be\u09a5\u09c0 / \u0986\u09df\u09c1\u09b7\u09cd\u09ae\u09be\u09a8 \u09ad\u09be\u09b0\u09a4",
    name_en = "Swasthya Sathi / Ayushman Bharat",
    note_bn = "\u098f\u0996\u09a8 \u09a6\u09c1\u099f\u09cb \u09b8\u09cd\u0995\u09bf\u09ae\u0987 \u09aa\u09b6\u09cd\u099a\u09bf\u09ae\u09ac\u0999\u09cd\u0997\u09c7 \u099a\u09be\u09b2\u09c1 \u2014 \u09a6\u09c1\u099f\u09cb \u0995\u09be\u09b0\u09cd\u09a1\u0987 \u09ac\u09cd\u09af\u09ac\u09b9\u09be\u09b0\u09af\u09cb\u0997\u09cd\u09af\u0964",
    note_en = "Both schemes now run in West Bengal \u2014 either card should be accepted where empanelled.",

    issues = list(

      hospital_refused = list(
        label_bn = "\u09b9\u09be\u09b8\u09aa\u09be\u09a4\u09be\u09b2\u09c7 \u0995\u09be\u09b0\u09cd\u09a1 \u0995\u09be\u099c \u0995\u09b0\u099b\u09c7 \u09a8\u09be",
        label_en = "The card isn't working at the hospital",
        question_bn = "\u09b9\u09be\u09b8\u09aa\u09be\u09a4\u09be\u09b2 \u09a0\u09bf\u0995 \u0995\u09c0 \u09ac\u09b2\u099b\u09c7?",
        question_en = "What exactly is the hospital saying?",
        options = list(

          not_empanelled = list(
            label_bn = "\u098f\u0987 \u09b9\u09be\u09b8\u09aa\u09be\u09a4\u09be\u09b2 \u09a4\u09be\u09b2\u09bf\u0995\u09be\u09ad\u09c1\u0995\u09cd\u09a4 \u09a8\u09df \u09ac\u09b2\u099b\u09c7",
            label_en = "Says this hospital isn't empanelled",
            diagnosis_bn = "\u09b8\u09ac \u09b9\u09be\u09b8\u09aa\u09be\u09a4\u09be\u09b2 \u09a4\u09be\u09b2\u09bf\u0995\u09be\u09ad\u09c1\u0995\u09cd\u09a4 \u09a8\u09df \u2014 \u09a8\u09bf\u0995\u099f\u09ac\u09b0\u09cd\u09a4\u09c0 \u09b8\u09b0\u0995\u09be\u09b0\u09bf \u09b9\u09be\u09b8\u09aa\u09be\u09a4\u09be\u09b2 \u09aa\u09cd\u09b0\u09be\u09df \u09b8\u09ac\u09b8\u09ae\u09df\u0987 \u09a4\u09be\u09b2\u09bf\u0995\u09be\u09ad\u09c1\u0995\u09cd\u09a4\u0964",
            diagnosis_en = "Not every hospital is empanelled — the nearest government hospital almost always is.",
            steps_bn = c(
              "Swasthya Sathi বা Ayushman Bharat পোর্টালে empanelled হাসপাতালের তালিকা দেখুন।",
              "জরুরি অবস্থায় নিকটবর্তী সরকারি হাসপাতালে যান এবং কার্ড দেখান।"
            ),
            steps_en = c(
              "Check the empanelled hospital list on the Swasthya Sathi or Ayushman Bharat portal.",
              "In an emergency, go to the nearest government hospital and present the card there."
            )
          ),

          reimbursement_dispute = list(
            label_bn = "\u09b9\u09be\u09b8\u09aa\u09be\u09a4\u09be\u09b2 \u098f\u09ae\u09a8\u09bf\u099f\u09c7\u0987 \u09aa\u09cd\u09b0\u09a4\u09cd\u09af\u09be\u0996\u09cd\u09af\u09be\u09a8 \u0995\u09b0\u099b\u09c7",
            label_en = "The hospital is refusing outright, no clear reason",
            diagnosis_bn = "\u0995\u09bf\u099b\u09c1 \u09ac\u09c7\u09b8\u09b0\u0995\u09be\u09b0\u09bf \u09b9\u09be\u09b8\u09aa\u09be\u09a4\u09be\u09b2 \u09ac\u09b8\u09b0\u0995\u09be\u09b0\u09bf\u09ad\u09be\u09ac\u09c7 \u09aa\u09cd\u09b0\u09a4\u09bf\u09aa\u09c2\u09b0\u09a3\u09c7 \u09a6\u09c7\u09b0\u09bf\u09b0 \u0995\u09be\u09b0\u09a3\u09c7 \u0995\u09be\u09b0\u09cd\u09a1 \u09ac\u09a8\u09cd\u09a7 \u0995\u09b0\u09c7 \u09a6\u09c7\u09df \u2014 \u098f\u099f\u09be \u09b0\u09cb\u0997\u09c0\u09b0 \u0985\u09a7\u09bf\u0995\u09be\u09b0\u09c7\u09b0 \u09b2\u0999\u09cd\u0998\u09a8, \u0985\u09ad\u09bf\u09af\u09cb\u0997 \u0995\u09b0\u09be \u09af\u09c7\u09a4\u09c7 \u09aa\u09be\u09b0\u09c7\u0964",
            diagnosis_en = "Some private hospitals informally decline the scheme over reimbursement-delay disputes with the government — that's a violation of the patient's right, not something you should absorb the cost of.",
            steps_bn = c(
              "হাসপাতালের Swasthya Sathi/Ayushman কাউন্টারে গিয়ে সরাসরি হেল্পলাইনে ফোন করতে বলুন — 1800-111-009।",
              "সমাধান না হলে জরুরি অবস্থায় নিকটবর্তী সরকারি হাসপাতালে যান।",
              "পরে স্বাস্থ্য দপ্তরে লিখিত অভিযোগ জানান — এই ধরনের প্রত্যাখ্যান নিয়মবিরুদ্ধ।"
            ),
            steps_en = c(
              "Ask the hospital's Swasthya Sathi/Ayushman counter to call the helpline directly — 1800-111-009.",
              "If unresolved and it's urgent, go to the nearest government hospital instead.",
              "File a written complaint with the Health Department afterward — this kind of refusal is against the rules."
            )
          )
        )
      ),

      agent = list(
        label_bn = "\u0995\u09c7\u0989 \u0986\u09ac\u09c7\u09a6\u09a8\u09c7\u09b0 \u099c\u09a8\u09cd\u09af \u099f\u09be\u0995\u09be \u099a\u09be\u0987\u099b\u09c7",
        label_en = "Someone is asking for money to apply",
        question_bn = NULL, question_en = NULL, options = NULL, direct_warning = TRUE
      )
    )
  )
)

agent_warning <- list(
  title_bn = "\u09b8\u09a4\u09b0\u09cd\u0995\u09a4\u09be: \u0995\u09cb\u09a8\u09cb \u09b8\u09b0\u0995\u09be\u09b0\u09bf \u09b8\u09cd\u0995\u09bf\u09ae\u09c7\u09b0 \u0986\u09ac\u09c7\u09a6\u09a8\u09c7 \u099f\u09be\u0995\u09be \u09b2\u09be\u0997\u09c7 \u09a8\u09be",
  title_en = "Warning: no government scheme application requires payment",
  body_bn = c(
    "যেকোনো সরকারি স্কিমে আবেদন করা সম্পূর্ণ বিনামূল্যে। কেউ 'দ্রুত অনুমোদনের' জন্য টাকা চাইলে সেটা প্রতারণা।",
    "শুধুমাত্র Duare Sarkar ক্যাম্প, BDO/SDO অফিস, বা wb.gov.in-এর মতো সরকারি পোর্টাল ব্যবহার করুন।",
    "টাকা চাওয়া হলে স্থানীয় BDO অফিসে অভিযোগ করুন, অথবা রাজ্য হেল্পলাইনে ফোন করুন।"
  ),
  body_en = c(
    "Applying for any government scheme is completely free. If anyone asks for money for 'faster approval', that is a scam.",
    "Only use Duare Sarkar camps, the BDO/SDO office, or official portals like wb.gov.in.",
    "If someone asks you for money, report it at your local BDO office or call the state helpline."
  )
)

scheme_choices_named <- function() {
  setNames(names(content), sapply(content, function(x) paste0(x$name_bn, " \u00b7 ", x$name_en)))
}

# ============================================================
# 2. UI
# ============================================================

ui <- fluidPage(
  tags$head(
    tags$link(rel = "preconnect", href = "https://fonts.googleapis.com"),
    tags$link(rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Tiro+Bangla:ital@0;1&family=Hind+Siliguri:wght@400;500;600;700&display=swap"),
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css")
  ),

  div(class = "app-header",
    div(class = "brand-bn", "\u0986\u09aa\u09a8\u09be\u09b0 \u0985\u09a7\u09bf\u0995\u09be\u09b0"),
    div(class = "brand-en", "APONAR ADHIKAR \u00b7 Your Entitlement"),
    div(class = "brand-tag", "\u0986\u09aa\u09a8\u09be\u09b0 \u09b8\u09ae\u09b8\u09cd\u09af\u09be \u09ac\u09c1\u099d\u09c1\u09a8 \u2014 What's going wrong, and what to do next")
  ),

  div(class = "app-wrap",
    tabsetPanel(
      id = "main_tabs", type = "tabs",

      tabPanel("\u09b8\u09ae\u09b8\u09cd\u09af\u09be\u09b0 \u09b8\u09ae\u09be\u09a7\u09be\u09a8 \u00b7 Fix a problem",
        br(),
        uiOutput("step_ui")
      ),

      tabPanel("\u09b8\u09ac \u09aa\u09cd\u09b0\u0995\u09b2\u09cd\u09aa \u00b7 Browse all schemes",
        br(),
        div(class = "card",
          fluidRow(
            column(6, textInput("browse_search", NULL, placeholder = "\u0996\u09c1\u0981\u099c\u09c1\u09a8 \u00b7 Search by name or benefit...")),
            column(6, selectInput("browse_category", NULL, choices = c("All categories" = "", sort(unique(all_schemes$category)))))
          ),
          div(class = "count-note", textOutput("browse_count", inline = TRUE))
        ),
        uiOutput("browse_table")
      )
    )
  ),

  div(class = "app-footer",
    HTML("This is an independent, unofficial tool and is not affiliated with the Government of West Bengal. Scheme rules changed significantly in 2026 \u2014 always confirm final details on the relevant official portal or at a Duare Sarkar camp before applying.<br>এটি একটি স্বাধীন, বেসরকারি সহায়ক টুল এবং পশ্চিমবঙ্গ সরকারের সাথে যুক্ত নয়।")
  )
)


# ============================================================
# 3. SERVER
# ============================================================

server <- function(input, output, session) {

  # ---- Tab 1: troubleshooting wizard ----
  state <- reactiveValues(step = 0, scheme = NULL, issue = NULL, option = NULL)

  reset_all <- function() {
    state$step <- 0; state$scheme <- NULL; state$issue <- NULL; state$option <- NULL
  }

  observeEvent(input$start, { state$step <- 1 })
  observeEvent(input$go_agent_quick, {
    state$scheme <- input$quick_scheme
    state$issue <- "agent"
    state$step <- 4
  })
  observeEvent(input$pick_scheme, {
    req(input$scheme_choice)
    state$scheme <- input$scheme_choice
    state$step <- 2
  })
  observeEvent(input$pick_issue, {
    req(input$issue_choice)
    state$issue <- input$issue_choice
    issue_data <- content[[state$scheme]]$issues[[state$issue]]
    state$step <- if (isTRUE(issue_data$direct_warning)) 4 else 3
  })
  observeEvent(input$pick_option, {
    req(input$option_choice)
    state$option <- input$option_choice
    state$step <- 4
  })
  observeEvent(input$back, { if (state$step > 0) state$step <- state$step - 1 })
  observeEvent(input$restart, { reset_all() })

  output$step_ui <- renderUI({

    if (state$step == 0) {
      return(tagList(
        div(class = "card intro-card",
          h2("\u0986\u09aa\u09a8\u09be\u09b0 \u09b8\u09ae\u09b8\u09cd\u09af\u09be\u09b0 \u09aa\u09cd\u09b0\u0995\u09be\u09b0 \u09ac\u09c7\u099b\u09c7 \u09a8\u09bf\u09a8"),
          p(class = "lede-bn", "\u0985\u09a8\u09cd\u09a8\u09aa\u09c2\u09b0\u09cd\u09a3\u09be \u09ad\u09be\u09a3\u09cd\u09a1\u09be\u09b0, \u09b0\u09c7\u09b6\u09a8 \u0995\u09be\u09b0\u09cd\u09a1 \u09ac\u09be \u09b8\u09cd\u09ac\u09be\u09b8\u09cd\u09a5\u09cd\u09af \u09b8\u09be\u09a5\u09c0\u09b0 \u099f\u09be\u0995\u09be \u09ac\u09be \u09b8\u09c1\u09ac\u09bf\u09a7\u09be \u0986\u099f\u0995\u09c7 \u0997\u09c7\u09b2\u09c7, \u09aa\u09a6\u09be\u09a8\u09c1\u09b8\u09be\u09b0\u09c7 \u09ac\u09c7\u099b\u09c7 \u0995\u09be\u09b0\u09a3 \u0996\u09c1\u0981\u099c\u09c7 \u09a8\u09bf\u09a8\u0964"),
          p(class = "lede-en", "For Annapurna Bhandar, Ration Card, or Swasthya Sathi/Ayushman Bharat \u2014 if your money or benefit is stuck, find out why and what to do."),
          actionButton("start", "\u09b6\u09c1\u09b0\u09c1 \u0995\u09b0\u09c1\u09a8 \u00b7 Start", class = "btn-primary btn-lg")
        ),
        div(class = "card quick-card",
          h3("\u0995\u09c7\u0989 \u0995\u09bf \u099f\u09be\u0995\u09be \u099a\u09be\u0987\u099b\u09c7 \u0986\u09ac\u09c7\u09a6\u09a8\u09c7\u09b0 \u099c\u09a8\u09cd\u09af? \u00b7 Is someone asking you for money to apply?"),
          fluidRow(
            column(6, selectInput("quick_scheme", NULL, choices = scheme_choices_named())),
            column(6, actionButton("go_agent_quick", "\u098f\u0996\u09a8\u0987 \u09b8\u09a4\u09b0\u09cd\u0995\u09a4\u09be \u09a6\u09c7\u0996\u09c1\u09a8 \u00b7 See the warning now", class = "btn-warn"))
          )
        )
      ))
    }

    if (state$step == 1) {
      return(div(class = "card",
        div(class = "step-label", "\u09a7\u09be\u09aa 1 \u00b7 Step 1"),
        h3("\u0995\u09cb\u09a8 \u09aa\u09cd\u09b0\u0995\u09b2\u09cd\u09aa \u09b8\u09ae\u09cd\u09aa\u09b0\u09cd\u0995\u09bf\u09a4? \u00b7 Which scheme is this about?"),
        radioButtons("scheme_choice", NULL, choices = scheme_choices_named(), selected = character(0)),
        div(class = "btn-row", actionButton("pick_scheme", "\u09aa\u09b0\u09ac\u09b0\u09cd\u09a4\u09c0 \u00b7 Next", class = "btn-primary"))
      ))
    }

    if (state$step == 2) {
      req(state$scheme)
      sc <- content[[state$scheme]]
      issue_choices <- setNames(names(sc$issues),
        sapply(sc$issues, function(x) paste0(x$label_bn, " \u00b7 ", x$label_en)))
      return(div(class = "card",
        div(class = "step-label", "\u09a7\u09be\u09aa 2 \u00b7 Step 2"),
        h3(paste0(sc$name_bn, " \u2014 \u0995\u09c0 \u09b8\u09ae\u09b8\u09cd\u09af\u09be \u09b9\u099a\u09cd\u099b\u09c7? \u00b7 What's going wrong?")),
        if (!is.null(sc$note_bn)) div(class = "sub-note", p(sc$note_bn), p(class = "sub-note-en", sc$note_en)),
        radioButtons("issue_choice", NULL, choices = issue_choices, selected = character(0)),
        div(class = "btn-row",
          actionButton("back", "\u09aa\u09c7\u099b\u09a8\u09c7 \u00b7 Back", class = "btn-secondary"),
          actionButton("pick_issue", "\u09aa\u09b0\u09ac\u09b0\u09cd\u09a4\u09c0 \u00b7 Next", class = "btn-primary"))
      ))
    }

    if (state$step == 3) {
      req(state$scheme, state$issue)
      iss <- content[[state$scheme]]$issues[[state$issue]]
      opt_choices <- setNames(names(iss$options),
        sapply(iss$options, function(x) paste0(x$label_bn, " \u00b7 ", x$label_en)))
      return(div(class = "card",
        div(class = "step-label", "\u09a7\u09be\u09aa 3 \u00b7 Step 3"),
        h3(paste0(iss$question_bn, " \u00b7 ", iss$question_en)),
        radioButtons("option_choice", NULL, choices = opt_choices, selected = character(0)),
        div(class = "btn-row",
          actionButton("back", "\u09aa\u09c7\u099b\u09a8\u09c7 \u00b7 Back", class = "btn-secondary"),
          actionButton("pick_option", "\u09b8\u09ae\u09be\u09a7\u09be\u09a8 \u09a6\u09c7\u0996\u09c1\u09a8 \u00b7 Show me what to do", class = "btn-primary"))
      ))
    }

    if (state$step == 4) {
      req(state$scheme, state$issue)
      iss <- content[[state$scheme]]$issues[[state$issue]]

      if (isTRUE(iss$direct_warning)) {
        return(div(class = "card result-card warn-card-bg",
          h3(agent_warning$title_bn), h4(agent_warning$title_en),
          tags$ul(lapply(agent_warning$body_bn, tags$li)),
          tags$ul(lapply(agent_warning$body_en, tags$li)),
          div(class = "btn-row", actionButton("restart", "\u0986\u09ac\u09be\u09b0 \u09b6\u09c1\u09b0\u09c1 \u0995\u09b0\u09c1\u09a8 \u00b7 Start over", class = "btn-primary"))
        ))
      }

      opt <- iss$options[[state$option]]
      return(div(class = "card result-card",
        div(class = "step-label", "\u0986\u09aa\u09a8\u09be\u09b0 \u099c\u09a8\u09cd\u09af \u00b7 For you"),
        h3(opt$diagnosis_bn), p(class = "diagnosis-en", opt$diagnosis_en),
        h4("\u0995\u09c0 \u0995\u09b0\u09ac\u09c7\u09a8 \u00b7 What to do"),
        tags$ol(lapply(seq_along(opt$steps_bn), function(i) {
          tags$li(div(class = "step-bn", opt$steps_bn[i]), div(class = "step-en", opt$steps_en[i]))
        })),
        div(class = "btn-row", actionButton("restart", "\u0986\u09ac\u09be\u09b0 \u09b6\u09c1\u09b0\u09c1 \u0995\u09b0\u09c1\u09a8 \u00b7 Start over", class = "btn-secondary"))
      ))
    }
  })

  # ---- Tab 2: browse all schemes ----
  filtered_schemes <- reactive({
    df <- all_schemes
    if (nzchar(input$browse_category)) df <- df[df$category == input$browse_category, ]
    if (nzchar(input$browse_search)) {
      term <- tolower(input$browse_search)
      hay <- tolower(paste(df$name_en, df$benefit))
      df <- df[grepl(term, hay, fixed = TRUE), ]
    }
    df
  })

  output$browse_count <- renderText({
    paste0("Showing ", nrow(filtered_schemes()), " of ", nrow(all_schemes), " schemes")
  })

  output$browse_table <- renderUI({
    df <- filtered_schemes()
    if (nrow(df) == 0) return(div(class = "card", p("No schemes match that search.")))
    tagList(lapply(seq_len(nrow(df)), function(i) {
      row <- df[i, ]
      div(class = "card scheme-row",
        div(class = "scheme-row-top",
          div(h4(row$name_en), if (nzchar(row$name_bn)) div(class = "bn-name", row$name_bn)),
          div(class = "cat-badge", row$category)
        ),
        div(class = "status-line", row$status),
        div(class = "benefit-line", row$benefit),
        div(class = "apply-line", strong("How to apply: "), row$apply),
        div(class = "contact-line", strong("Contact: "), row$contact)
      )
    }))
  })
}

shinyApp(ui, server)