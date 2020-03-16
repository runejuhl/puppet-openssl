openssl_version_raw = if Facter::Util::Resolution.which('openssl')
                        Facter::Util::Resolution.exec('openssl version 2>&1')
                      end

if openssl_version_raw
  matches = %r{^OpenSSL ([\w\.\-]+)( FIPS)?([ ]+)([\d\.]+)([ ]+)([\w\.]+)([ ]+)([\d\.]+)}.match(openssl_version_raw)
  version = matches[1] if matches

  Facter.add(:openssl_version) do
    setcode do
      version
    end
  end

  Facter.add(:openssl, type: :aggregate) do
    chunk(:fips) do
      { fips: !!openssl_version_raw.match(/\Wfips\W/i)}
    end

    chunk(:version) do
      version
    end
  end

end
