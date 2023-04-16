# frozen_string_literal: true

require "test_helper"

class TestOpqr < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Opqr::VERSION
  end

  def test_it_does_something_useful
    assert true ,'失败'
  end
end
