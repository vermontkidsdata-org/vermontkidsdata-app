import OpenAI from "openai";
import { AnnotationDelta, FileCitationDeltaAnnotation } from "openai/resources/beta/threads/messages";
import { ChunkHandler, Footnote, resetAIUtils, setFileMap, } from '../src/ai-utils';

// jest.mock('openai', () => {
//   return {
//     files: {
//       retrieve: async (file_id: string) => {
//         console.log({ message: '*** openai.files.retrieve', file_id });
//       },
//     },
//   };
// });

export const TEST_FILE_MAP = [{
  "filename": "how_are_vermonts_young_children_2023.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf",
  "name": "The State of Vermont's Children 2023 Year in Review",
}, {
  "filename": "how_are_vermonts_young_children_2022.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/State-of-Vermonts-Children-2022.pdf",
  "name": "The State of Vermont's Children 2022",
}, {
  "filename": "how_are_vermonts_young_children_2021.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2022/01/The-State-of-Vermonts-Children-2021-Year-in-Review.pdf",
  "name": "The State of Vermont's Children 2021 Year in Review",
}, {
  "filename": "how_are_vermonts_young_children_2020.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2021/01/2020-How-Are-Vermonts-Young-Children-and-Families.pdf",
  "name": "How Are Vermont's Young Children and Families 2020",
}, {
  "filename": "how_are_vermonts_young_children_2019.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2020/01/BBF-2019-HAVYCF-REPORT-SinglePgs.pdf",
  "name": "How Are Vermont's Young Children 2019",
}, {
  "filename": "how_are_vermonts_young_children_2018.txt",
  "url": "https://buildingbrightfutures.org/wp-content/uploads/2019/01/BBF-2018-HAVYCF-FINAL-SINGLES-1.pdf",
  "name": "How Are Vermont's Young Children 2018",
}];

describe('ai-utils', () => {
  describe('handleChunk', () => {
    const annotations: AnnotationDelta[] = [];
    const footnotes: Footnote[] = [];
    let chunkHandler: ChunkHandler;
    const openai = {
      files: {
        retrieve: async (file_id: string) => {
          console.log({ message: '*** openai.files.retrieve', file_id });
          return {
            id: file_id,
            filename: 'how_are_vermonts_young_children_2023.txt',
            purpose: 'my-purpose',
            bytes: 37,
          }
        },
      },
    } as unknown as OpenAI;

    beforeEach(() => {
      annotations.length = 0;
      footnotes.length = 0;
      chunkHandler = new ChunkHandler();
      resetAIUtils();
    });

    it('should handle chunk with no refs', async () => {
      const result = await chunkHandler.handleChunk({
        openai: {} as OpenAI,
        finished: false,
        chunk: 'chunk',
        annotations: [],
        footnotes: [],
        refnum: 0,
      });

      expect(result).toEqual({
        cleanChunk: 'chunk',
        refnum: 0,
      });

      // Only one chunk, so it's the same
      expect(result.cleanChunk).toBe(chunkHandler.getMessage());
    });

    it('should handle chunk with annotations', async () => {
      setFileMap(TEST_FILE_MAP);
      const result = await chunkHandler.handleChunk({
        openai,
        finished: false,
        chunk: 'chunk <<text>> rest-of-chunk',
        annotations: [{
          file_citation: {
            file_id: 'my-file-id',
          } as FileCitationDeltaAnnotation.FileCitation,
          index: 0,
          type: 'file_citation',
          text: '<<text>>',
        }],
        footnotes,
        refnum: 0,
      });

      console.log({ result, footnotes });
      expect(result).toEqual({
        cleanChunk: 'chunk [[1]](https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf) rest-of-chunk',
        refnum: 1,
      });
      expect(footnotes).toEqual([{
        refnum: 1,
        filename: 'how_are_vermonts_young_children_2023.txt',
        url: 'https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf',
        file_id: 'my-file-id',
      }]);
      // Only one chunk, so it's the same
      expect(result.cleanChunk).toBe(chunkHandler.getMessage());
    });

    it('should not duplicate annotations', async () => {
      setFileMap(TEST_FILE_MAP);
      await chunkHandler.handleChunk({
        openai,
        finished: false,
        chunk: 'chunk <<text>> rest-of-chunk',
        annotations: [{
          file_citation: {
            file_id: 'my-file-id',
          } as FileCitationDeltaAnnotation.FileCitation,
          index: 0,
          type: 'file_citation',
          text: '<<text>>',
        }],
        footnotes,
        refnum: 0,
      });
      await chunkHandler.handleChunk({
        openai,
        finished: false,
        chunk: '<<text>>',
        annotations: [{
          file_citation: {
            file_id: 'my-file-id',
          } as FileCitationDeltaAnnotation.FileCitation,
          index: 0,
          type: 'file_citation',
          text: '<<text>>',
        }],
        footnotes,
        refnum: 0,
      });
      await chunkHandler.handleChunk({
        openai,
        finished: false,
        chunk: 'last chunk',
        annotations: [],
        footnotes,
        refnum: 0,
      });

      expect(chunkHandler.getMessage()).toBe('chunk [[1]](https://buildingbrightfutures.org/wp-content/uploads/the_state_of_vermonts_children_2023_year_in_review.pdf) rest-of-chunklast chunk');
    });
  });
});