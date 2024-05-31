package local.vo;

public class BoardLike {
	private int boardLikeId;
	private int boardId;
	private int createdBy;
	private String createdId;
	private String createdAt;
	private int count;
	
	
	public int getBoardLikeId() {
		return boardLikeId;
	}
	public void setBoardLikeId(int boardLikeId) {
		this.boardLikeId = boardLikeId;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}
	public String getCreatedId() {
		return createdId;
	}
	public void setCreatedId(String createdId) {
		this.createdId = createdId;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
	
	
	
	
	
}
