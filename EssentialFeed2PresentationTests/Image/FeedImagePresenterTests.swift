//
//  FeedImagePresenterTests 2.swift
//  EssentialFeed2PresentationTests
//
//  Created by Donatas Žitkus on 21/06/2025.
//


import Foundation
import XCTest
import EssentialFeed2
import EssentialFeed2Presentation

class FeedImagePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingImageData_startsLoading() {
        let (sut, view) = makeSUT()
        let feedImage = makeImage()
        
        sut.didStartLoadingImageData(for: feedImage)
        
        XCTAssertEqual(view.messages, [
            .display(feedImage.toViewModel(isLoading: true))
        ])
    }
    
    func test_didFinishLoadingImageDataSuccessfully_displaysLoadedImage() {
        let (sut, view) = makeSUT()
        let feedImage = makeImage()
        let imageData = anyImageData()

        sut.didFinishLoadingImageDataSuccessfully(with: imageData, for: feedImage)
        
        XCTAssertEqual(view.messages, [
            .display(feedImage.toViewModel(isLoading: false, shouldRetry: false, image: imageData))
        ])
    }
    
    func test_didFinishLoadingImageDataSuccessfully_displaysRetryAndDoesNotDisplayImageWhenTransformedImageDoesNotExistOrWasTransformedUnsuccessfully() {
        let failingImageTransformer = imageTransformer { _ in nil }
        let (sut, view) = makeSUT(imageTransformer: failingImageTransformer)
        let feedImage = makeImage()
        let imageData = anyImageData()
        
        sut.didFinishLoadingImageDataSuccessfully(with: imageData, for: feedImage)
        
        XCTAssertEqual(view.messages, [
            .display(feedImage.toViewModel(isLoading: false, shouldRetry: true, image: nil))
        ])
    }
    
    func test_didFinishLoadingImageDataUnsuccessfully_displaysRetry() {
        let (sut, view) = makeSUT()
        let feedImage = makeImage()
        
        sut.didFinishLoadingImageDataUnsuccessfully(with: anyNSError(), for: feedImage)
        
        XCTAssertEqual(view.messages, [
            .display(feedImage.toViewModel(isLoading: false, shouldRetry: true, image: nil))
        ])
    }
    
    
    // MARK: - Helpers
    private func makeSUT(imageTransformer: @escaping (Data) -> TransformedImageData? = { data in data }, file: StaticString = #filePath, line: UInt = #line) -> (FeedImagePresenter<ViewSpy, Data>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view, imageTransformer: imageTransformer)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(view, file: file, line: line)
        return (sut, view)
    }
    
    private func makeImage(description: String? = nil, location: String? = nil) -> FeedImage {
        return FeedImage(id: UUID(), description: description, location: location, url: anyURL())
    }
    
    private func imageTransformer(_ completion: @escaping (Data) -> TransformedImageData?) -> (Data) -> TransformedImageData? {
        return completion
    }
    
    private func anyImageData() -> Data {
        return Data("any image".utf8)
    }
    
    private typealias TransformedImageData = Data
    
    private class ViewSpy: FeedImageView {
        typealias Image = Data
        
        enum Message: Hashable {
            case display(FeedImageViewModel<Data>)
        }
        
        var messages = Set<Message>()
        
        func display(_ model: FeedImageViewModel<Data>) {
            messages.insert(.display(model))
        }
    }
}

private extension FeedImage {
    func toViewModel<Image: Hashable>(isLoading: Bool = false, shouldRetry: Bool = false, image: Image? = nil) -> FeedImageViewModel<Image> {
        return FeedImageViewModel(description: description, location: location, image: image, isLoading: isLoading, shouldRetry: shouldRetry)
    }
}
