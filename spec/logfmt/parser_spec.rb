require 'spec_helper'
require 'logfmt/parser'

describe Logfmt::Parser do
  it 'parse empty log line' do
    data = Logfmt.parse("")
    expect(data).to eq({})
  end

  it 'parse whitespace only log line' do
    data = Logfmt.parse("\t")
    expect(data).to eq({})
  end

  it 'parse key without value' do
    data = Logfmt.parse("key")
    expect(data).to eq({:key => true})
  end

  it 'parse key without value and whitespace' do
    data = Logfmt.parse("  key  ")
    expect(data).to eq({:key => true})
  end

  it 'parse multiple single keys' do
    data = Logfmt.parse("key1 key2")
    expect(data).to eq({:key1 => true, :key2 => true})
  end

  it 'parse unquoted value' do
    data = Logfmt.parse("key=value")
    expect(data).to eq({:key => "value"})
  end

  it 'parse pairs' do
    data = Logfmt.parse("key1=value1 key2=value2")
    expect(data).to eq({:key1 => "value1", :key2 => "value2"})
  end

  it 'parse mixed single/non-single pairs' do
    data = Logfmt.parse("key1=value1 key2")
    expect(data).to eq({:key1 => "value1", :key2 => true})
  end

  it 'parse mixed pairs whatever the order' do
    data = Logfmt.parse("key1 key2=value2")
    expect(data).to eq({:key1 => true, :key2 => "value2"})
  end

  it 'parse quoted value' do
    data = Logfmt.parse('key="quoted value"')
    expect(data).to eq({:key => "quoted value"})
  end

  it 'parse escaped quote value' do
    data = Logfmt.parse('key="quoted \" value"')
    expect(data).to eq({:key => 'quoted " value'})
  end

  it 'parse mixed pairs' do
    data = Logfmt.parse('key1="quoted \" value" key2 key3=value3')
    expect(data).to eq({:key1 => 'quoted " value', :key2 => true, :key3 => "value3"})
  end

  it 'parse mixed characters pairs' do
    data = Logfmt.parse('foo=bar a=14 baz="hello kitty" cool%story=bro f %^asdf')
    expect(data).to eq({:foo => "bar", :a => "14", :baz => "hello kitty", :"cool%story" => "bro", :f => true, :"%^asdf" => true})
  end

  it 'parse pair with empty quote' do
    data = Logfmt.parse('key=""')
    expect(data).to eq({:key => ""})
  end

  it 'parse mixed unicode characters pairs' do
    data = Logfmt.parse('a=1 b="bar" ƒ=2h3s r="esc\t" d x=sf')
    expect(data).to eq({:a => "1", :b => "bar", :ƒ => "2h3s", :r => "esc\t", :d => true, :x => "sf"})
  end
end
