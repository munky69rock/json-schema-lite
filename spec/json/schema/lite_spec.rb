require 'spec_helper'
require 'json'
require 'json-schema'

describe JSON::Schema::Lite do
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

  describe JSON::Schema::Lite::Object do
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

    it 'returns json schema object' do
      expect(JSON::Schema::Lite.define(definition)).to eql expected
    end

    it 'returns valid json schema' do
      expect(JSON::Validator.validate JSON::Schema::Lite.generate(definition), json_obj, validate_schema: true, strict: true).to be true
    end
  end

  describe JSON::Schema::Lite::Block do
    let(:schema_obj) do
      JSON::Schema::Lite.define do
        string :title, required: true
        string :body, required: true
        number :vote
        object :author do
          string :name
        end
        array :tags, :string
        array :related do
          string :title
        end
      end
    end

    let(:json_schema) do
      JSON::Schema::Lite.generate do
        string :title, required: true
        string :body, required: true
        number :vote
        object :author do
          string :name
        end
        array :tags, :string
        array :related do
          string :title
        end
      end
    end

    it 'returns json schema object' do
      expect(JSON::Schema::Lite.define {
               string :title, required: true
               string :body, required: true
               number :vote
               object :author do
                 string :name
               end
               array :tags, :string
               array :related do
                 string :title
               end
             }).to eql expected
    end

    it 'returns valid json schema' do
      expect(JSON::Validator.validate json_schema, json_obj, validate_schema: true, strict: true).to be true
    end
  end
end
