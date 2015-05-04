require 'spec_helper'

describe Owner do
  describe "#buildpacks" do
    context "new owner" do
      let(:owner) { Owner.new(feature_switches: {other_feature: "1"}) }
      it { expect(owner.buildpacks).to be_truthy }

      context "buildpacks explicitly enabled" do
        before(:each) { owner.buildpacks = "1"}
        it { expect(owner.buildpacks).to be_truthy }
      end

      context "buildpacks explicitly disabled" do
        before(:each) { owner.buildpacks = "0"}
        it { expect(owner.buildpacks).to be_falsy }
      end
    end
  end
end