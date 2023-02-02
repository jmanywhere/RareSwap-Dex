from brownie import TheRareAntiquitiesTokenLtd, interface, accounts, reverts
import pytest


@pytest.fixture(scope="module")
def setup():
    dev = accounts[0]
    mkt = accounts[1]
    atwallet = accounts[2]
    gasWallet = accounts[3]
    trusted = accounts[4]
    token = TheRareAntiquitiesTokenLtd.deploy(
        mkt, atwallet, gasWallet, trusted, {"from": dev}
    )
    pair = interface.IPancakePair(token.rareSwapPair())
    router = interface.IPancakeSwapRouter(token.rareSwapRouter())
    return token, dev, pair, router


def test_init(setup, web3):
    token, dev, pair, router = setup
    assert (
        token.balanceOf(dev)
        == web3.toWei(500_000_000_000, "gwei")
        == token.totalSupply()
    )
    assert token._totalTax() == 700  # 7%


def test_transfer(setup, web3):
    token, dev, pair, router = setup
    user1 = accounts[5]
    user2 = accounts[6]
    assert token.balanceOf(dev) == web3.toWei(500_000_000_000, "gwei")

    # Test private functions
    # getValues = token._getValues(web3.toWei(5_000_000_000, "gwei"))
    # assert getValues["tTransferAmount"] == web3.toWei(5_000_000_000, "gwei")
    # assert getValues["tFee"] == 0

    # Transfer 1% of total supply/
    token.transfer(user1, web3.toWei(5_000_000_000, "gwei"), {"from": dev})

    # Check balances
    assert token.balanceOf(dev) == web3.toWei(495_000_000_000, "gwei")
    assert token.balanceOf(user1) == web3.toWei(5_000_000_000, "gwei")

    with reverts("Trade disabled"):
        token.transfer(user2, web3.toWei(1_000_000_000, "gwei"), {"from": user1})


def test_transfer_exclusions(setup, web3):
    token, dev, pair, router = setup

    user1 = accounts[5]
    user2 = accounts[6]
    user3 = accounts[7]
    user4 = accounts[8]

    # Enable trading
    token.EnableTrading({"from": dev})
    # set exclusion statuses
    token.excludeFromReward(user1, {"from": dev})
    token.excludeFromReward(user2, {"from": dev})

    # Transfer between excluded addresses
    token.transfer(user2, web3.toWei(1_000_000_000, "gwei"), {"from": user1})
    assert token.balanceOf(user1) == web3.toWei(4_000_000_000, "gwei")
    taxed_val = web3.toWei(1_000_000_000, "gwei") * 7 // 100
    assert token.balanceOf(user2) == web3.toWei(1_000_000_000, "gwei") - taxed_val
    # Transfer between excluded and non-excluded addresses
    token.transfer(user3, web3.toWei(1_000_000_000, "gwei"), {"from": user1})
    assert token.balanceOf(user1) == web3.toWei(3_000_000_000, "gwei")
    assert token.balanceOf(user3) == web3.toWei(1_000_000_000, "gwei") - taxed_val
    # Transfer between non-excluded addresses
    token.transfer(user4, web3.toWei(1_000_000, "gwei"), {"from": user3})
    taxed_val_2 = web3.toWei(1_000_000, "gwei") * 7 // 100
    assert (
        token.balanceOf(user3)
        == web3.toWei(1_000_000_000, "gwei") - taxed_val - taxed_val_2
    )
    assert token.balanceOf(user4) == web3.toWei(1_000_000, "gwei") - taxed_val_2
    # Transfer between non-excluded to excluded addresses
    token.transfer(user1, web3.toWei(1_000_000, "gwei"), {"from": user3})
    assert (
        token.balanceOf(user1)
        == web3.toWei(3_000_000_000, "gwei")
        + web3.toWei(1_000_000, "gwei")
        - taxed_val_2
    )
    pass


def test_fee_changes(setup, web3):
    pass


def test_owner_only(setup, web3):
    token, dev, pair, router = setup
    user1 = accounts[5]
    user2 = accounts[6]
    with reverts("Ownable: caller is not the owner"):
        token.excludeFromReward(user2, {"from": user1})
    with reverts("Ownable: caller is not the owner"):
        token.excludeFromFee(user2, {"from": user1})
    with reverts("Ownable: caller is not the owner"):
        token.includeInFee(user2, {"from": user1})
    pass
