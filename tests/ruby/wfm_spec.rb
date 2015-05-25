#!/usr/bin/env rspec

require_relative "test_helper"

require "yast"

module Yast
  describe WFM do
    describe ".CallFunction" do
      it "calls yast client via component system returning its value" do
        expect(WFM.CallFunction("test_client")).to eq 15
      end

      it "always properly initialize client (BNC#861529)" do
        expect(WFM.CallFunction("test_client")).to eq 15
        expect(WFM.CallFunction("test_client")).to eq 15
      end

      it "produces no warning (about redefined constants)" do
        # require_relative does not work in -e
        helper = $LOADED_FEATURES.grep(/test_helper/).first
        script = <<-EOS
          load '#{helper}'
          require 'yast'
          Yast::WFM.CallFunction('test_client')
          Yast::WFM.CallFunction('test_client')
        EOS
        stdout_stderr = `ruby -e "#{script}" 2>&1`
        expect(stdout_stderr).to eq ""
      end
    end

    describe ".local_wfm?" do
      it "returns true for local scr" do
        expect(WFM.local_scr?).to eq true
      end

      it "returns false for remote scr" do
        old_handle = WFM.SCRGetDefault
        handle = WFM.SCROpen("chroot=/tmp:scr", false)
        WFM.SCRSetDefault(handle)

        expect(WFM.local_scr?).to eq false

        WFM.SCRSetDefault(old_handle)
      end
    end
  end
end
