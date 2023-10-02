class SRLINUX < Oxidized::Model
  using Refinements

  #
  # Nokia SR Linux
  # 
  # Used in 7220 IXR D2(L), D3(L) models and 7250 IXR variants
  #

  comment '# '

  # Multiline prompt, control chars filtered below
  prompt /\s[:]([\w.@_()-:]+[#]\s+)$/

  # replace all used vt100 control sequences with a single space
  # expect /\e\[\??\w+(;\w+)*/ do |data, re|
  expect /\e\[\??\w+/ do |data, re|
    data.gsub re, ' '
  end


#  cmd :all do |cfg, cmdstring|
#    new_cfg = comment "COMMAND: #{cmdstring}\n"
#    cfg.gsub! /# Finished .*/, ''
#    cfg.gsub! /# Generated .*/, ''
#    cfg.delete! "\r"
#    new_cfg << cfg.cut_both
#  end

  #
  # Show the chassis information.
  #
  cmd 'show /platform chassis' do |cfg|
    comment cfg.lines.to_a[0..25].reject { |line| line.match /state|Time|Temperature|Status/ }.join
  end

  #
  # Show the running configuration.
  #
  cmd 'info from running' do |cfg|
    cfg
  end

  cfg :ssh do
    pre_logout 'quit'
  end
end
