Puppet::Parser::Functions::newfunction(
  :tinc_keygen,
  :type => :rvalue,
  :doc =>
  "tinc_keygen($network[, $base_dir[, $keygen_util [, $bits]]])
   return value: [key.pri, key.pub]
   It will generate the keypair if both do not exist.
   It will also generate the directory hierarchy if required.") do |args|
  raise Puppet::ParseError, "Wrong number of arguments" if args.to_a.length < 2 or args.to_a.length > 3

  network = args[0]

  dir = File.join(args[1] ? args[1] : '/etc/tinc', network)
  unless File.directory?(dir)
    require 'fileutils'
    FileUtils.mkdir_p(dir, :mode => 0700)
  end

  private_key_path = File.join(dir,"rsa_key.priv")
  public_key_path = File.join(dir,"rsa_key.pub")

  keygen_util = args[2]
  bits = args[3]
  unless [private_key_path,public_key_path].all?{|path| File.exists?(path) }
    output = Puppet::Util.execute([keygen_util, '-c', dir, '-n', network, '-K', bits])
    raise Puppet::ParseError, "Something went wrong during key generation! Output: #{output}" unless output =~ /Generating .* bits keys/
  end
  [File.read(private_key_path),File.read(public_key_path)]
end
