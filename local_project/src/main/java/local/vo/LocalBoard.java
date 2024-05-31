package local.vo;

public class LocalBoard {
	private int lbId; 		// 게시글 ID (기본키)
	private String localId;		// 지역 ID  (외래키)
	private int fileId; 		// 파일 ID (외래키)
	private int createdBy; 		// 등록한회원 ID (외래키)
	private String createdIp; 	// 등록한 사람 IP
	private String createdAt; 	// 등록 일시
	private String modifiedAt;  // 수정 일시
	private int modifiedBy; 	// 수정한 회원
	private String modifiedIp;  // 수정한 사람 IP
	private String title; 		// 제목
	private String content; 	// 내용
	private int hit; 			// 조회수
	private char delyn; 		// 삭제여부
	private String nicknm;		// 닉네임
	private int commentCount;	//댓글수
	private String localExtra; //참고항목(동)
	private String postCode; //우편번호
	private String addr; //주소
	private String addrDetail; //상세주소
	public int getLbId() {
		return lbId;
	}
	public void setLbId(int lbId) {
		this.lbId = lbId;
	}
	public String getLocalId() {
		return localId;
	}
	public void setLocalId(String localId) {
		this.localId = localId;
	}
	public int getFileId() {
		return fileId;
	}
	public void setFileId(int fileId) {
		this.fileId = fileId;
	}
	public int getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(int createdBy) {
		this.createdBy = createdBy;
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
	public String getNicknm() {
		return nicknm;
	}
	public void setNicknm(String nicknm) {
		this.nicknm = nicknm;
	}
	public int getCommentCount() {
		return commentCount;
	}
	public void setCommentCount(int commentCount) {
		this.commentCount = commentCount;
	}
	public String getLocalExtra() {
		return localExtra;
	}
	public void setLocalExtra(String localExtra) {
		this.localExtra = localExtra;
	}
	public String getPostCode() {
		return postCode;
	}
	public void setPostCode(String postCode) {
		this.postCode = postCode;
	}
	public String getAddr() {
		return addr;
	}
	public void setAddr(String addr) {
		this.addr = addr;
	}
	public String getAddrDetail() {
		return addrDetail;
	}
	public void setAddrDetail(String addrDetail) {
		this.addrDetail = addrDetail;
	}
	
	
	
}
