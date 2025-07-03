//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeed2Tests
//
//  Created by Donatas Žitkus on 23/06/2025.
//

import XCTest
import EssentialFeed2
import EssentialFeedAPI

class RemoteFeedImageDataLoaderTests: XCTestCase {
    func test_loadImageData_deliversDataOnValidHTTPResponse() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        let data = anyData()

        expect(sut, toCompleteWith: .success(data), when: {
            client.complete(withStatusCode: 200, data: data)
        }, for: url)
    }
    
    func test_loadImageData_doesNotDeliverResultAfterCancellingTask() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        let data = anyData()

        var receivedResults = [FeedImageDataLoader.Result]()
        let task = sut.loadImageData(from: url) { receivedResults.append($0) }
        task.cancel()

        client.complete(withStatusCode: 200, data: data)

        XCTAssertTrue(receivedResults.isEmpty, "Expected no result after cancelling task")
    }
    
    func test_loadImageData_deliversErrorOnInvalidData() {
        let (sut, client) = makeSUT()
        let url = anyURL()
        let invalidData = Data()

        expect(sut, toCompleteWith: .failure(RemoteFeedImageDataLoader.Error.invalidData), when: {
            client.complete(withStatusCode: 200, data: invalidData)
        }, for: url)
    }
    
    func test_loadImageData_deliversErrorOnConnectivityFailure() {
        let (sut, client) = makeSUT()
        let url = anyURL()

        expect(sut, toCompleteWith: .failure(RemoteFeedImageDataLoader.Error.connectivity), when: {
            client.complete(with: NSError(domain: "Test", code: 0))
        }, for: url)
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (RemoteFeedImageDataLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeak(client, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }

    private func expect(_ sut: RemoteFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, for url: URL, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        _ = sut.loadImageData(from: url) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)

            case let (.failure(receivedError as RemoteFeedImageDataLoader.Error),
                      .failure(expectedError as RemoteFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()
        wait(for: [exp], timeout: 1.0)
    }

    private func anyURL() -> URL {
        return URL(string: "https://a-url.com")!
    }

    private func anyData() -> Data {
        return Data("image-data".utf8)
    }

    private final class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()

        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
            messages.append((url, completion))
            return Task { [weak self] in
                self?.cancelledURLs.append(url)
            }
        }

        private(set) var cancelledURLs: [URL] = []

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success((data, response)))
        }

        private struct Task: HTTPClientTask {
            let cancelCallback: () -> Void

            func cancel() {
                cancelCallback()
            }
        }
    }
}
