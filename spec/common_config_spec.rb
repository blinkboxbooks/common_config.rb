context Blinkbox::CommonConfig do
  subject(:properties) {
    properties = load_properties <<-PROPS
      my_key = value
      another_key = another value
      logging.host = hostname.com
      logging.port = 1234
      logging = isn't in the tree for logging.
      delay = 5 seconds
      long_delay = 5 minutes
    PROPS
  }

  describe "#[]" do
    it "must return the value alphanumeric property symbol keys" do
      expect(properties[:my_key]).to eq("value")
    end

    it "must be indifferent to symbol or string access" do
      expect(properties["my_key"]).to eq(properties[:my_key])
    end

    it "must return nil if the property is not defined" do
      expect(properties[:doesnt_exist]).to be_nil
    end

    it "must return a number with a unit for properties in the right format" do
      expect(properties[:delay].convert_to("seconds").scalar).to eq(5)
    end

    it "must return numbers with other units in a convertible format" do
      expect(properties[:long_delay].convert_to("seconds").scalar).to eq(5 * 60)
    end
  end

  describe "#tree" do
    it "must return all keys in the specified tree as a hash" do
      expected_hash = {
        host: "hostname.com",
        port: 1234
      }
      expect(properties.tree(:logging)).to eq(expected_hash)
    end

    it "must also return trees when using strings" do
      expect(properties.tree("logging")).to eq(properties.tree(:logging))
    end

    it "must return an empty hash if there are no matches" do
      expect(properties.tree(:absent)).to eq({})
    end

    it "must not return partial matches" do
      expect(properties.tree(:log)).to eq({})
    end
  end
end