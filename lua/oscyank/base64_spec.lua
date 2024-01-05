local b64 = require("oscyank.base64")

describe("Test for base64.lua", function()
  it("encode", function()
    assert.equal("YWJjZGVmZw==", b64.encode("abcdefg"))
  end)
end)
