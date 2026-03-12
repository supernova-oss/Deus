extern "C" {
  #include <LLQM/LLQMColor.h>
  #include <LLQM/LLQMQuark.h>
}

#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include <doctest.hpp>

TEST_CASE("Gets flavor") {
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkUpRed) == UP);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkUpGreen) == UP);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkUpBlue) == UP);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkDownRed) == DOWN);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkDownGreen) == DOWN);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkDownBlue) == DOWN);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkStrangeRed) == STRANGE);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkStrangeGreen) == STRANGE);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkStrangeBlue) == STRANGE);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkCharmRed) == CHARM);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkCharmGreen) == CHARM);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkCharmBlue) == CHARM);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkBottomRed) == BOTTOM);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkBottomGreen) == BOTTOM);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkBottomBlue) == BOTTOM);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkTopRed) == TOP);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkTopGreen) == TOP);
  CHECK(LLQMQuarkGetFlavor(LLQMQuarkTopBlue) == TOP);
}

TEST_CASE("Gets color") {
  CHECK(LLQMQuarkGetColor(LLQMQuarkUpRed) == RED);
  CHECK(LLQMQuarkGetColor(LLQMQuarkUpGreen) == GREEN);
  CHECK(LLQMQuarkGetColor(LLQMQuarkUpBlue) == BLUE);
  CHECK(LLQMQuarkGetColor(LLQMQuarkDownRed) == RED);
  CHECK(LLQMQuarkGetColor(LLQMQuarkDownGreen) == GREEN);
  CHECK(LLQMQuarkGetColor(LLQMQuarkDownBlue) == BLUE);
  CHECK(LLQMQuarkGetColor(LLQMQuarkStrangeRed) == RED);
  CHECK(LLQMQuarkGetColor(LLQMQuarkStrangeGreen) == GREEN);
  CHECK(LLQMQuarkGetColor(LLQMQuarkStrangeBlue) == BLUE);
  CHECK(LLQMQuarkGetColor(LLQMQuarkCharmRed) == RED);
  CHECK(LLQMQuarkGetColor(LLQMQuarkCharmGreen) == GREEN);
  CHECK(LLQMQuarkGetColor(LLQMQuarkCharmBlue) == BLUE);
  CHECK(LLQMQuarkGetColor(LLQMQuarkBottomRed) == RED);
  CHECK(LLQMQuarkGetColor(LLQMQuarkBottomGreen) == GREEN);
  CHECK(LLQMQuarkGetColor(LLQMQuarkBottomBlue) == BLUE);
  CHECK(LLQMQuarkGetColor(LLQMQuarkTopRed) == RED);
  CHECK(LLQMQuarkGetColor(LLQMQuarkTopGreen) == GREEN);
  CHECK(LLQMQuarkGetColor(LLQMQuarkTopBlue) == BLUE);
}

TEST_CASE("Up-type quarks have electric charge of ⅔ e") {
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkUpRed) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkUpGreen) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkUpBlue) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkCharmRed) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkCharmGreen) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkCharmBlue) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkTopRed) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkTopGreen) == 2.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkTopBlue) == 2.0 / 3.0);
}

TEST_CASE("Down-type quarks have electric charge of -⅓ e") {
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkDownRed) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkDownGreen) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkDownBlue) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkStrangeRed) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkStrangeGreen) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkStrangeBlue) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkBottomRed) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkBottomGreen) == -1.0 / 3.0);
  CHECK(LLQMQuarkGetElectricCharge(LLQMQuarkBottomBlue) == -1.0 / 3.0);
}
