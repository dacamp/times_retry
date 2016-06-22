require 'test_helper'

class TimesRetryTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::TimesRetry::VERSION
  end

  def test_times_retry
    assert_silent do
      2.times_retry do
        sleep 0.1
      end
    end
  end

  def test_times_retry_a_quick_break
    assert_silent do
      Timeout::timeout(1) do
        1000.times_retry do
          sleep 0.1
        end
      end
    end
  end

  def test_times_retry_returns_value
    assert_equal 1.times_retry { "FixnumTest" }, "FixnumTest"
  end

  def test_times_retry_timeout
    assert_raises Timeout::Error do
      Timeout::timeout(0.1) do
        1.times_retry do
          sleep 0.5
        end
      end
    end
  end

  def test_times_retry_standard_error
    out, err = capture_io do
      assert_raises StandardError do
        2.times_retry do
          raise StandardError, 'FixnumText Error'
        end
      end
    end

    assert(out.empty?)
    errors = err.split("\n")
    assert_equal(errors.size, 2)
    assert_equal(errors.first, "StandardError: FixnumText Error will retry 2 more times")
    assert_equal(errors.last, "StandardError: FixnumText Error will retry 1 more time")
  end

  # Some readability is lost here, but times_retry will rescue
  # ArgumentError only, while the assert is looking for
  # RuntimeError only
  #
  # For most exceptions, times_retry will output error messages
  # Unhandled exceptions get re-raised.
  def test_times_retry_uncaught_exception
    assert_raises RuntimeError do
      out, err = capture_io do
        2.times_retry(nil, ArgumentError) do
          raise RuntimeError, 'FixnumText Error'
        end
      end

      assert(out.empty?)
      assert_equal(err.size, 2)
      assert_equal(err.last, 'RuntimeError: FixnumText Error')
      assert_equal($!.class.name, "Exception")
    end
  end

end
