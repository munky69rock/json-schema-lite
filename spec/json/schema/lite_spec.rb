require 'spec_helper'
require 'json'
require 'json-schema'

describe JSON::Schema::Lite do
  let(:definition) do
    {
      type: :object,
      required: [:title, :body],
      properties: {
        title: :string,
        body: :string,
        vote: :number,
        author: {
          type: :object,
          properties: {
            name: :string,
          }
        },
        tags: [:string],
        related: [
          type: :object,
          properties: {
            title: :string
          }
        ]
      }
    }
  end

  let(:expected) do
    {
      type: :object,
      required: [:title, :body],
      properties: {
        title: { type: :string },
        body: { type: :string },
        vote: { type: :number },
        author: {
          type: :object,
          properties: {
            name: { type: :string }
          }
        },
        tags: {
          type: :array,
          items: {
            type: :string 
          }
        },
        related: {
          type: :array,
          items: {
            type: :object,
            properties: {
              title: { type: :string }
            }
          }
        }
      }
    }
  end

  let(:json_obj) do
    {
      title: 'title',
      body: 'texttexttext',
      vote: 20,
      author: { name: 'author_name' },
      tags: ['tag1', 'tag2'],
      related: [
        { title: 'related1' },
        { title: 'related2' }
      ]

    }
  end

  it 'has a version number' do
    expect(JSON::Schema::Lite::VERSION).not_to be nil
  end

  it 'returns json schema object' do
    expect(JSON::Schema::Lite.define(definition)).to eql expected
  end

  it 'returns valid json schema' do
    expect(JSON::Validator.validate JSON::Schema::Lite.generate(definition), json_obj, validate_schema: true, strict: true).to be true
  end
end
