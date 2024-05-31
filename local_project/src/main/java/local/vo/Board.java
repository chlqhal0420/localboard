package local.vo;

public class Board {
	private int boardId; 		// 게시글 ID (기본키)
	private String localId;		// 지역 ID  (외래키)
	private int createdBy; 		// 등록한회원 ID (외래키)
	private int fileId; 		// 파일 ID (외래키)
	private String createdIp; 	// 등록한 사람 IP
	private String createdAt; 	// 등록 일시
	private String modifiedAt;  // 수정 일시
	private int modifiedBy; 	// 수정한 회원
	private String modifiedIp;  // 수정한 사람 IP
	private String title; 		// 제목
	private String content; 	// 내용
	private int hit; 			// 조회수
	private char delyn; 		// 삭제여부
	private char type;			// 게시판 구분
	private String nicknm;
	private int commentCount;   //댓글수
	
	
	
	
	public int getCommentCount() {
		return commentCount;
	}
	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}
	public String getNicknm() {
		return nicknm;
	}
	public void setNicknm(String nicknm) {
		this.nicknm = nicknm;
	}
	public int getBoardId() {
		return boardId;
	}
	public void setBoardId(int boardId) {
		this.boardId = boardId;
	}
	public String getLocalId() {
		return localId;
	}
	public void setLocalId(String localId) {
		this.localId = localId;
	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
	}
	public int getFileId() {
		return fileId;
	}
	public void setFileId(int fileId) {
		this.fileId = fileId;
	}
	public String getCreatedIp() {
		return createdIp;
	}
	public void setCreatedIp(String createdIp) {
		this.createdIp = createdIp;
	}
	public String getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}
	public String getModifiedAt() {
		return modifiedAt;
	}
	public void setModifiedAt(String modifiedAt) {
		this.modifiedAt = modifiedAt;
	}
	public int getModifiedBy() {
		return modifiedBy;
	}
	public void setModifiedBy(int modifiedBy) {
		this.modifiedBy = modifiedBy;
	}
	public String getModifiedIp() {
		return modifiedIp;
	}
	public void setModifiedIp(String modifiedIp) {
		this.modifiedIp = modifiedIp;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public int getHit() {
		return hit;
	}
	public void setHit(int hit) {
		this.hit = hit;
	}
	public char getDelyn() {
		return delyn;
	}
	public void setDelyn(char delyn) {
		this.delyn = delyn;
	}
	public char getType() {
		return type;
	}
	public void setType(char type) {
		this.type = type;
	}
	
	
	
	
	
	
	
	
	
	
}
