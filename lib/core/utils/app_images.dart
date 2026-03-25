class AppImages {
static String appBarLongImg = "assets/img/appBarLong.svg.vec";
static String appBarLongGreen = "assets/img/appBarLongGreen.svg";

static String appBarShortImg = "assets/img/appBarShort.svg.vec";
static String discountsImg = "assets/img/discounts.svg.vec";
static String paymentsModalImg = "assets/img/paymentModal.svg.vec";
static String cardImg = "assets/img/cardImage.svg.vec";
static String logoImg = "assets/img/logo.svg.vec";
static String loginImg = "assets/img/loginImg.svg.vec";
static String bottomWave = "assets/img/bottomWave.svg.vec";
static String whiteLogo = "assets/img/whiteLogo.svg.vec";
static String loginBackground = "assets/img/loginBackground.jpg";
static String successfulSale = "assets/img/successfulSale.vec.svg";
static String deleteCardModal = "assets/img/deleteCardModal.svg.vec";
static String confirmRechargeAmountIcon = "assets/img/confirmAmount.png";
static String pickSaleDateLogo = "assets/img/pickDateLogo.png";
static String noResultsLogo = "assets/img/noResults.png";

static String emailVerification = "assets/img/email_verification.png";

static String defaultProfileImage = "assets/img/defaultProfileImage.jpg";
static String defaultProductImage = "assets/img/defaultProductImage.png";
static String defaultProfileStudentImage = "assets/img/defaultStudentImage.png";
static String itemPlaceholderImage = "assets/img/itemPlaceholderImage.png";
static String successfulSaleImage = "assets/img/successfulSaleImage.svg.vec";


static String updateAppImage = "assets/img/update-app.png";

static String mastercardLogo = "assets/img/mastercardLogo.png";
static String americanExpressLogo = "assets/img/americanExpress.png";
static String bancoAztecaLogo = "assets/img/bancoAzteca.png";
static String bbvaLogo = "assets/img/bbva.png";
static String carnetLogo = "assets/img/carnet.png";
static String citibanamexLogo = "assets/img/citibanamex.png";
static String inbursaLogo = "assets/img/inbursa.png";
static String masterCardText = "assets/img/mastercardText.png";
static String openpayColor = "assets/img/openpayColor.png";
static String openpayWhite = "assets/img/openpayWhite.png";
static String santanderLogo = "assets/img/santander.png";
static String scotiabankLogo = "assets/img/scotiabank.png";
static String visaLogo = "assets/img/visa.png";



static String openpayLogo = "assets/img/openpay_banner.png";
static String supportLogo = "assets/img/support_banner.png";


static String croemLogo = "assets/img/croem_logo.png";
static String croemSupport = "assets/img/Croem_support.png";


static String successRecharge = "assets/img/successRecharge.svg";
static String errorRecharge = "assets/img/errorRecharge.svg";


static String dishIcon = "assets/img/dish_icon.png";
static String clockIcon = "assets/img/clock_icon.png";


static String panamaSale = "assets/img/panama_sale.png";
static String panamaPresale = "assets/img/panama_presale.png";
static String panama_multisale = "assets/img/panama_multisale.png";


static String smartLunchIcon = "assets/img/smartlunchlogo.png";

static String yappiImage = "assets/img/yappi.png";

static String supportImage = "assets/img/support_agent.png";


static String membershipDebt = "assets/img/membership_payment.png";

static String mercadoPagoLogo = "assets/img/mercado_pago.png";



static String getCardBrandImage(String brand) {
  switch (brand) {
    case "mastercard":
      return mastercardLogo;
    case "visa":
      return visaLogo;
    case "american_express":
      return americanExpressLogo;
    default:
      return visaLogo;
  }
}

}
